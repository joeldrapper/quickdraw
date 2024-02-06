# frozen_string_literal: true

require "json"

class Quickdraw::Run
	def initialize(number_of_processes:, number_of_threads: 1, test_files:)
		@number_of_processes = number_of_processes
		@number_of_threads = number_of_threads
		@test_files = test_files.shuffle

		@cluster = Quickdraw::Cluster.new
		@batches = Array.new(@number_of_processes) { [] }

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
		@batches.each_with_index do |batch, index|
			queue = Quickdraw::Queue.new

			@cluster.fork do |writer|
				batch.each do |file|
					queue << [file, Class.new(Quickdraw::Context) do
						class_eval(File.read(file), file, 1)
					end]
				end

				# We enable YJIT here after the files have been loaded
				RubyVM::YJIT.enable

				@number_of_threads.times.map {
					Thread.new { Quickdraw::Runner.new(queue).call }
				}.map!(&:value).each_with_index do |result, thread|
					writer.write({
						process: index + 1,
						thread: thread + 1,
						result: result
					}.to_json)
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
