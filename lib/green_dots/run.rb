# frozen_string_literal: true

class GreenDots::Run
	def initialize(number_of_processes:, directory:, test_files:)
		@number_of_processes = number_of_processes
		@directory = directory
		@test_files = test_files.shuffle

		@cluster = GreenDots::Cluster.new
		@batches = Array.new(@number_of_processes) { [] }

		@test_files.each_with_index do |file, index|
			@batches[index % @number_of_processes] << file
		end
	end

	def call
		report_time do
			load_directory
			require "helper"
			fork_processes
			@results = @cluster.wait
			puts_results
		end
	end

	def report_time(&)
		total_time = GreenDots.timer(&)
		puts "Total time: #{total_time.ms}ms"
	end

	def load_directory
		$LOAD_PATH.unshift File.expand_path("#{@directory}/support")
	end

	def fork_processes
		result = GreenDots::Result.new
		@batches.each_with_index do |batch, index|
			@cluster.fork do |writer|
				GreenDots::SomeRunner.new(writer, batch, result, index).call
			end
		end
	end

	def puts_results
		puts
		puts
		puts "Collated results: \n#{@results.join("\n")}"
	end
end
