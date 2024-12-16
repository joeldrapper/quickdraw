# frozen_string_literal: true

require "json"
require "io/console"

class Quickdraw::Runner
	MESSAGE = {
		fetch: 1,
		work: 2,
		stop: 3,
		stopping: 4,
	}.freeze

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

		@failures.each do |it|
			puts it
		end

		puts
		puts "Ran with seed: #{@seed}"
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

	def failure!
		@failures << yield
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
			socket.write [MESSAGE[:fetch]].pack("C")

			case socket.read(1)&.unpack1("C")
			when nil
				puts "EOF"
				break
			when MESSAGE[:stop]
				socket.write [MESSAGE[:stopping]].pack("C")
				socket.write JSON.generate(@failures)
				break
			when MESSAGE[:work]
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
				message = socket.read(1)&.unpack1("C")
				tests_length = @tests.size

				case message
				when nil
					break
				when MESSAGE[:fetch]
					mutex.synchronize do
						if @cursor < tests_length
							socket.write [MESSAGE[:work], @cursor].pack("CL<")
							@cursor += batch
						else
							socket.write [MESSAGE[:stop]].pack("C")
						end
					end

					new_progress = (@cursor * 100 / tests_length).round

					if new_progress != progress
						progress = new_progress
						print "\r\e[K#{'█' * (progress * bar_width / 100)}#{'░' * (bar_width - (progress * bar_width / 100))} #{progress}%"
					end
				when MESSAGE[:stopping]
					results = JSON.parse(socket.read)
					@failures << results
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
