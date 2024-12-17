# frozen_string_literal: true

module Quickdraw::Timer
	extend self
	autoload :Duration, "quickdraw/timer/duration"

	def time
		start = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
		yield
		finish = Process.clock_gettime(Process::CLOCK_MONOTONIC, :nanosecond)
		Duration.new(finish - start)
	end
end
