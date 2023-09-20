# frozen_string_literal: true

class GreenDots::TimeElapsed
	def initialize(start, finish)
		@start = start
		@finish = finish
	end

	def time
		@finish - @start
	end

	alias_method :ms, :time

	def seconds
		time / 1_000
	end
end
