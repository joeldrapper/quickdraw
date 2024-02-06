# frozen_string_literal: true

class Quickdraw::Timer::Duration
	def initialize(duration)
		@duration = duration
	end

	def to_s
    if @duration < 1_000
   	"#{@duration}ns"
		elsif @duration < 1_000_000
			"#{@duration / 1_000}μs"
		elsif @duration < 1_000_000_000
			"#{@duration / 1_000_000}ms"
		elsif @duration < 60_000_000_000
			"#{@duration / 1_000_000_000}s"
		else
			"#{(@duration / 60_000_000_000)}m"
		end
  end
end
