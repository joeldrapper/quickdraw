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

		@pipes.map do |reader|
			reader.read.tap { reader.close }
		end
	end
end
