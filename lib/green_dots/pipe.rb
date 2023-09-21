# frozen_string_literal: true

class GreenDots::Pipe
	def initialize
		@reader, @writer = IO.pipe
	end

	def with_writer
		@reader.close
		yield(@writer)
		@writer.close
	end

	def with_reader
		@writer.close
		yield(@reader)
		@reader.close
	end
end
