# frozen_string_literal: true

class GreenDots::Worker
	def self.fork(&)
		reader, writer = IO.pipe

		pid = Process.fork do
			reader.close
			yield(writer)
			writer.close
		end

		writer.close

		new(pid:, reader:)
	end

	def initialize(pid:, reader:)
		@pid = pid
		@reader = reader
	end

	def wait
		Process.wait(@pid)
		@reader.read.tap { @reader.close }
	end
end
