# frozen_string_literal: true

class Quickdraw::Timer
	autoload :Duration, "quickdraw/timer/duration"

	def self.time
		start = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
		yield
		finish = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
		Duration.new(finish - start)
	end
end
