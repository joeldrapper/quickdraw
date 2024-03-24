# frozen_string_literal: true

require "json"

class Quickdraw::Run
	def initialize(processes:, threads:, files:, seed:)
		files = files.shuffle(random: Random.new(seed))
		number_of_files = files.size
		processes = [processes, number_of_files].min
		batches = Array.new(processes) { [] }

		i = 0
		while i < number_of_files
			batches[i % processes] << files[i]
			i += 1
		end

		@threads = threads
		@seed = seed
		@cluster = Quickdraw::Cluster.new
		@batches = batches
	end

	def call
		fork_processes
		@results = @cluster.wait
		puts_results
	end

	def fork_processes
		@batches.each_with_index do |batch, index|
			queue = Quickdraw::Queue.new

			@cluster.fork do |writer|
				i = 0
				batch_size = batch.size

				while i < batch_size
					file_path = batch[i]

					queue << [file_path, Class.new(Quickdraw::Context) do
						class_eval(File.read(file_path), file_path, 1)
					end]

					i += 1
				end

				# We enable YJIT here after the files have been loaded
				RubyVM::YJIT.enable if Kernel.const_defined?("RubyVM::YJIT")

				results = []

				@threads.times.map {
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
		puts "Randomized with seed: #{@seed}"

		@results.each do |result|
			JSON.parse(result).each do |r|
				process, thread, (duration, successes, failures) = r
				puts "[Process: #{process}, Thread: #{thread}] Successes: #{successes.size}, Failures: #{failures.size}, in: #{duration}"
			end
		end
	end
end
