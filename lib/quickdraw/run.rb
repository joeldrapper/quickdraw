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
	end

	def call
		load_tests
		enable_yjit if yjit_supported?

		if @processes > 1
			fork_processes
			results = @cluster.wait.map { |it| JSON.parse(it) }
		else
			result = run_inline
			results = [result]
		end

		puts
		total_failures = 0

		results.each do |r|
			failures = r["failures"]
			errors = r["errors"]

			i = 0
			number_of_failures = failures.size
			total_failures += number_of_failures
			while i < number_of_failures
				failure = failures[i]
				test_name, path, lineno, message = failure
				puts "#{path}:#{lineno} in #{test_name.inspect}: #{message}"
				i += 1
			end

			number_of_errors = errors.size
			total_failures += number_of_errors
			while i < number_of_errors
				error = errors[i]
				test_name, cls, message, backtrace = error
				puts "Unexpected #{cls} in #{test_name}:\n#{message}\n#{backtrace.join("\n\t")}"
				i += 1
			end
		end

		puts "Ran with seed: #{@seed}"

		if total_failures > 0
			exit 1
		end
	end

	def load_tests
		number_of_files = @files.size
		i = 0

		while i < number_of_files
			run = self
			file_path = @files[i]

			Class.new(Quickdraw::Context) do
				set_temporary_name "Quickdraw::Context(in #{file_path})" if respond_to?(:set_temporary_name)
				define_singleton_method(:run) { run }
				class_eval(File.read(file_path), file_path, 1)
			end

			i += 1
		end

		@tests.shuffle!(random: @random)
		@tests.freeze
	end

	def batch_tests
		batches = Array.new([@processes, @tests.size].min) { Concurrent::Array.new }

		number_of_tests = @tests.size
		i = 0

		while i < number_of_tests
			batches[i % @processes] << @tests[i]
			i += 1
		end

		batches
	end

	def <<(test)
		@tests << test
	end

	def fork_processes
		batches = batch_tests
		number_of_batches = batches.size
		i = 0

		while i < number_of_batches
			queue = batches[i]

			@cluster.fork do |writer|
				results = Quickdraw::Runner.new(
					queue:,
					threads: @threads,
				).call

				writer.write(JSON.generate(results))
			end

			i += 1
		end
	end

	def run_inline
		queue = Concurrent::Array.new

		i = 0
		number_of_tests = @tests.size
		while i < number_of_tests
			queue << @tests[i]
			i += 1
		end

		Quickdraw::Runner.new(
			queue:,
			threads: @threads,
		).call
	end

	private

	def enable_yjit
		RubyVM::YJIT.enable
	end

	def yjit_supported?
		Quickdraw::Platform.yjit_supported?
	end
end
