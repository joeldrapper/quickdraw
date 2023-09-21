# frozen_string_literal: true

class GreenDots::Path
	def initialize(path)
		@path = path
	end

	def render
		@buffer = +""
		@path.compact.each_with_index do |item, index|
			@buffer << ("  " * index)
			@buffer << "└─ "

			@buffer << item << "\n"
		end

		@buffer
	end
end
