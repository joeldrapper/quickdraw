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
		results.each do |r|
			failures = r["failures"]

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

	def batch_tests
		batches = Array.new([@processes, @tests.size].min) { Quickdraw::Queue.new }

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
		queue = Quickdraw::Queue.new

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
