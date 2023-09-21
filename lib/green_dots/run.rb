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

	attr_reader :directory, :test_files

	def call
		total_time = GreenDots.timer do
			load_directory
			require "helper"
			fork_processes
			@results = @cluster.wait
			puts_results
		end

		puts "Total time: #{total_time.ms}ms"
	end

	def load_directory
		$LOAD_PATH.unshift File.expand_path("#{directory}/support")
	end

	def fork_processes
		result = GreenDots::Result.new
		@batches.each_with_index do |batch, index|
			@cluster.fork do |writer|
				batch_elapsed_time = GreenDots.timer do
					batch.each do |f|
						Class.new(GreenDots::Context) do
							class_eval(
								File.read(f), f, 1
							)
						end.run(result)
					end
				end

				writer.write("Process[#{index + 1}]: #{result.successes} assertions passed in #{batch_elapsed_time} milliseconds. #{SUCCESS_EMOJI.sample}")
				result.failures.each do |(message, backtrace)|
					writer.write "\n\n"
					writer.write message
					writer.write "\n"
					writer.write "#{backtrace.first.path}:#{backtrace.first.lineno}"
				end
			end
		end
	end

	def puts_results
		puts
		puts
		puts "Collated results: \n#{@results.join("\n")}"
	end
end
