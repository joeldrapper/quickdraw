# frozen_string_literal: true

class GreenDots::Timer
	class Duration
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

	def self.time
	  start = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
		yield
		finish = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
		Duration.new(finish - start)
	end
end
