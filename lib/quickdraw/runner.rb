# frozen_string_literal: true

require "json"
require "io/console"

class Quickdraw::Runner
	module Message
		Fetch = "\x01"
		Work = "\x02"
		Stop = "\x03"
		Stopping = "\x04"
	end

	def initialize(processes:, threads:, files:, seed:)
		@processes = processes
		@threads = threads
		@seed = seed
		@random = Random.new(seed)
		@files = files.shuffle(random: @random)
		@tests = []

		@mutex = Mutex.new
		@cursor = 0

		@cluster = Quickdraw::Cluster.new
		@batch = nil
		@failures = Quickdraw::ConcurrentArray.new
		@successes = Quickdraw::ConcurrentInteger.new
	end

	def call
		load_tests
		enable_yjit if yjit_supported?

		if @processes > 1
			fork_processes
			results = @cluster.wait
		else
			@tests.each { |it| it.run(self) }
		end

		@failures.each do |failure|
			puts "#{failure['location'][0]}:#{failure['location'][1]}"
			puts "  #{failure['description']}"
			puts "    #{failure['message']}"
			puts
		end

		puts

		puts "Passed: #{@successes.value} | Failed: #{@failures.size}"

		exit(1) if @failures.any?
	end

	def load_tests
		number_of_files = @files.size
		i = 0

		while i < number_of_files
			file_path = @files[i]

			Class.new(Quickdraw::Test) do
				set_temporary_name "(#{file_path})" if respond_to?(:set_temporary_name)
				class_eval(File.read(file_path), file_path, 1)
			end

			i += 1
		end

		@tests.shuffle!(random: @random)
		@tests.freeze

		# Try to break up the tests into at least 20 batches per core.
		@batch = [[(@tests.size / @processes / 20), 1].max, 500].min
	end

	def fork_processes
		Quickdraw::Config.before_forking_callbacks.each(&:call)

		@processes.times do
			worker = @cluster.fork { |it| work(it) }
			supervise(worker)
		end
	end

	def <<(test)
		@tests << test
	end

	def success!(description)
		@successes.increment
	end

	def failure!(failure)
		@failures << failure
	end

	private

	def work(socket)
		Quickdraw::Config.after_forking_callbacks.each(&:call)

		batch = @batch
		queue = Thread::SizedQueue.new(batch)
		tests = @tests
		tests_size = @tests.size

		threads = @threads.times.map do |i|
			Thread.new do
				while true
					index = queue.pop
					break if index == :stop
					context, description, skip, block = tests[index]
					context.new(description:, skip:, block:).run(self)
				end
			end
		end

		while true
			socket.write Message::Fetch

			case socket.read(1)
			when nil
				puts "EOF"
				break
			when Message::Stop
				threads.each { queue.push(:stop) }
				threads.each(&:join)
				socket.write Message::Stopping
				socket.write JSON.generate({
					failures: @failures.to_a,
					successes: @successes.value,
				})
				break
			when Message::Work
				cursor = socket.read(4).unpack1("L<")
				stop = [tests_size, cursor + batch].min

				while cursor < stop
					queue.push(cursor)
					cursor += 1
				end
			else
				raise "Unhandled message: #{message}"
			end
		end
	end

	def supervise(worker)
		socket = worker.socket
		mutex = @mutex
		results = nil
		batch = @batch
		progress = 0

		console = IO.console
		if console
			console_width = IO.console.winsize[1]
		end

		bar_width = console_width - 6

		Thread.new do
			while true
				message = socket.read(1)
				tests_length = @tests.size

				case message
				when nil
					break
				when Message::Fetch
					mutex.synchronize do
						if @cursor < tests_length
							socket.write Message::Work
							socket.write [@cursor].pack("L<")
							@cursor += batch
						else
							socket.write Message::Stop
						end
					end

					if console
						progress = (@cursor * 100.0 / tests_length)
						print "\r\e[K#{'█' * (progress * bar_width / 100.0).floor}#{'░' * (bar_width - (progress * bar_width / 100.0).floor)} #{progress.round}%"
					end
				when Message::Stopping
					results = JSON.parse(socket.read)
					@failures.concat(results["failures"])
					@successes.increment(results["successes"])
				else
					raise "Unhandled message: #{message}"
				end
			end
		end
	end

	def enable_yjit
		RubyVM::YJIT.enable
	end

	def yjit_supported?
		Quickdraw::Platform.yjit_supported?
	end
end
