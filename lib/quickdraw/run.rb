# frozen_string_literal: true

class Quickdraw::Run
	def initialize(number_of_processes:, number_of_threads: 1, test_files:)
		@number_of_processes = number_of_processes
		@number_of_threads = number_of_threads
		@test_files = test_files.shuffle

		@cluster = Quickdraw::Cluster.new
		@batches = Array.new(@number_of_processes) { Quickdraw::Queue.new }

		@test_files.each_with_index do |file, index|
			@batches[index % @number_of_processes] << file
		end
	end

	def call
		report_time do
			fork_processes
			@results = @cluster.wait
			puts_results
		end
	end

	def report_time(&)
		total_time = Quickdraw::Timer.time(&)
		puts "Total time: #{total_time}"
	end

	def fork_processes
		# Enable YJIT right before forking
		RubyVM::YJIT.enable

		@batches.each_with_index do |batch, index|
			@cluster.fork do |writer|
				results = @number_of_threads.times.map do
					Thread.new { Quickdraw::Runner.call(batch) }
				end.map(&:value)

				results.each_with_index do |result, thread|
					writer.write("\n")
					writer.write("Process[#{index + 1}], Thread[#{thread + 1}]: #{result.successes.count} assertions passed in #{result.duration}. #{Quickdraw::SUCCESS_EMOJI.sample}")
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
