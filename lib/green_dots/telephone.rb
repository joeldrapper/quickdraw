# frozen_string_literal: true

class GreenDots::Telephone
	def initialize
		@left_to_right = GreenDots::Pipe.new
		@right_to_left = GreenDots::Pipe.new
	end

	def left
		[@right_to_left.reader, @left_to_right.writer]
	end

	def right
		[@left_to_right.reader, @right_to_left.writer]
	end

	def from_left
		yield(*left).tap do
			@right_to_left.reader.close
			@left_to_write.writer.close
		end
	end

	def from_right
		yield(*right).tap do
			@left_to_right.reader.close
			@right_to_left.writer.close
		end
	end
end
