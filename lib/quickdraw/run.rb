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
		enable_yjit
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

	def <<(test)
		@tests << test
	end

	def fork_processes
		number_of_batches = batches.size
		i = 0

		while i < number_of_batches
			queue = batches[i]

			@cluster.fork do |writer|
				Quickdraw::Runner.new(
					queue:,
					writer:,
					threads: @threads
				).call
			end

			i += 1
		end
	end

	private def enable_yjit
		if yjit_supported?
			RubyVM::YJIT.enable
		end
	end

	private def yjit_supported?
		Kernel.const_defined?("RubyVM::YJIT") && RubyVM::YJIT.respond_to?(:enable)
	end
end
