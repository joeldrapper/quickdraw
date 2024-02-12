# frozen_string_literal: true

require "json"

class Quickdraw::Run
	def initialize(number_of_processes:, number_of_threads_per_process: 1, files:)
		@number_of_processes = [number_of_processes, files.size].min
		@number_of_threads_per_process = number_of_threads_per_process
		@files = files.shuffle

		@cluster = Quickdraw::Cluster.new
		@batches = Array.new(@number_of_processes) { [] }

		@files.each_with_index do |file, index|
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
		@batches.each_with_index do |batch, index|
			queue = Quickdraw::Queue.new

			@cluster.fork do |writer|
				batch.each do |file|
					queue << [file, Class.new(Quickdraw::Context) do
						class_eval(File.read(file), file, 1)
					end]
				end

				# We enable YJIT here after the files have been loaded
				RubyVM::YJIT.enable if Kernel.const_defined?("RubyVM::YJIT")

				results = []

				@number_of_threads_per_process.times.map {
					Thread.new { Quickdraw::Runner.new(queue).call }
				}.map!(&:value).each_with_index do |result, thread|
					results << [
						index + 1,
						thread + 1,
						result
					]
				end

				writer.write results.to_json
			end
		end
	end

	def puts_results
		puts
		puts

		@results.each do |result|
			JSON.parse(result).each do |r|
				process, thread, (duration, successes, failures) = r
				puts "[Process: #{process}, Thread: #{thread}] Successes: #{successes.size}, Failures: #{failures.size}, in: #{duration}"
			end
		end
	end
end
