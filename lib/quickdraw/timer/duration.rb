# frozen_string_literal: true

class Quickdraw::Timer::Duration
	def initialize(duration)
		@duration = duration.to_f
	end

	def to_s
		if @duration < 1_000
			"#{format("%.1f", @duration)}ns"
		elsif @duration < 1_000_000
			"#{format("%.1f", @duration / 1_000)}μs"
		elsif @duration < 1_000_000_000
			"#{format("%.1f", @duration / 1_000_000)}ms"
		elsif @duration < 60_000_000_000
			"#{format("%.1f", @duration / 1_000_000_000)}s"
		else
			"#{format("%.1f", @duration / 60_000_000_000)}m"
		end
	end
end
