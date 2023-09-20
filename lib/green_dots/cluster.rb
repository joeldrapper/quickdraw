# frozen_string_literal: true

class GreenDots::Cluster
	def initialize
		@pids = []
		@pipes = []
	end

	def fork
		reader, writer = IO.pipe

		@pipes << reader

		@pids << Process.fork do
			reader.close
			yield(writer)
			writer.close
		end

		writer.close
	end

	def wait
		freeze
		@pids.each { |pid| Process.wait(pid) }

		results = []

		@pipes.each do |reader|
			results << reader.read
			reader.close
		end

		results
	end
end
