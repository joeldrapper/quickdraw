# frozen_string_literal: true

require "json"

class Quickdraw::Run
	def initialize(processes:, threads:, files:, seed:)
		@processes = processes
		@threads = threads
		@seed = seed
		@random = Random.new(seed)
		@files = files.shuffle(random: @random)
		@tests = []

		@cluster = Quickdraw::Cluster.new

		@successes = Quickdraw::ConcurrentArray.new
		@failures = Quickdraw::ConcurrentArray.new
	end

	def call
		load_tests
		RubyVM::YJIT.enable if Kernel.const_defined?("RubyVM::YJIT")
		fork_processes
		results = @cluster.wait

		puts
		results.each do |result|
			result = JSON.parse(result)
			failures = result["failures"]

			i = 0
			number_of_failures = failures.size
			while i < number_of_failures
				failure = failures[i]
				path, lineno, message = failure
				puts "#{path}:#{lineno} #{message}"
				i += 1
			end
		end

		puts "Ran with seed: #{@seed}"
	end

	def load_tests
		number_of_files = @files.size
		i = 0

		while i < number_of_files
			run = self
			file_path = @files[i]

			Class.new(Quickdraw::Context) do
				define_singleton_method(:run) { run }
				class_eval(File.read(file_path), file_path, 1)
			end

			i += 1
		end

		@tests.shuffle!(random: @random)
		@tests.freeze
	end

	def batches
		batches = Array.new([@processes, @tests.size].min) { Quickdraw::Queue.new }

		number_of_tests = @tests.size
		i = 0

		while i < number_of_tests
			batches[i % @processes] << @tests[i]
			i += 1
		end

		batches
	end

	def success!(name)
		@successes << name

		Kernel.print(
			Quickdraw::Config.success_symbol
		)
	end

	def failure!
		location = caller_locations.drop_while { |it| !it.path.include?(".test.rb") }.first
		@failures << [location.path, location.lineno, yield]

		Kernel.print(
			Quickdraw::Config.failure_symbol
		)
	end

	def <<(test)
		@tests << test
	end

	def fork_processes
		number_of_batches = batches.size
		i = 0

		while i < number_of_batches
			queue = batches[i]

			@cluster.fork do |writer|
				threads = Array.new(@threads) do
					Thread.new do
						while true
							if (name, skip, test, context = queue.shift)
								context.init(name, skip).instance_exec(&test)
							else
								break
							end
						end
					end
				end

				threads.each(&:join)

				writer.write(
					{
						process: i + 1,
						pid: Process.pid,
						failures: @failures.to_a,
						successes: @successes.size
					}.to_json
				)
			end

			i += 1
		end
	end
end
