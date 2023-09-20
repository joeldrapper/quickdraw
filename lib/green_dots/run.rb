# frozen_string_literal: true

class GreenDots::Run
	def initialize
		@successes = 0
		@mutex = Mutex.new
	end

	attr_reader :successes

	def success!
		@mutex.synchronize do
			@successes += 1
		end

		::Kernel.print "\e[32m⚬\e[0m"
	end

	def failure!(message)
		raise(GreenDots::TestFailure, message)
	end
end
