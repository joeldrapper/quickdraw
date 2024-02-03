# frozen_string_literal: true

class GreenDots::Pipe
	def initialize
		@reader, @writer = IO.pipe
	end

	def reader
		@writer.close
		@reader
	end

	def writer
		@reader.close
		@writer
	end

	def with_writer
		@reader.close
		yield(@writer).tap { @writer.close }
	end

	def with_reader
		@writer.close
		yield(@reader).tap { @reader.close }
	end
end
