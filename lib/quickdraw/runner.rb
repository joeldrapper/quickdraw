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
		@failures = []
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

		puts
		puts

		@failures.each do |failure|
			puts "#{failure['location'][0]}:#{failure['location'][1]}"
			puts "  #{failure['description']}"
			puts "    #{failure['message']}"
			puts
		end

		puts

		if @failures.any?
			puts "Failures: #{@failures.size}"
		end

		puts "Seed: #{@seed}"
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

		# Try to break up the tests into at least 10 batches per core.
		@batch = [[(@tests.size / @processes / 10), 1].max, 500].min
	end

	def fork_processes
		@processes.times do
			worker = @cluster.fork { |it| work(it) }
			supervise(worker)
		end
	end

	def <<(test)
		@tests << test
	end

	def success!(description)
		# Kernel.print(Quickdraw::Config.success_symbol)
	end

	def failure!(failure)
		@failures << failure
	end

	private

	def work(socket)
		batch = @batch
		queue = Thread::SizedQueue.new(batch)
		tests = @tests
		tests_size = @tests.size

		threads = @threads.times.map do |i|
			Thread.new do
				while true
					description, skip, block = tests[queue.pop]
					Quickdraw::Test.new(description:, skip:, block:).run(self)
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
				socket.write Message::Stopping
				socket.write JSON.generate(@failures)
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

		console_width = IO.console.winsize[1]
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

					progress = (@cursor * 100.0 / tests_length)

					print "\r\e[K#{'█' * (progress * bar_width / 100.0).floor}#{'░' * (bar_width - (progress * bar_width / 100.0).floor)} #{progress.round}%"
				when Message::Stopping
					results = JSON.parse(socket.read)
					@failures.concat(results)
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
