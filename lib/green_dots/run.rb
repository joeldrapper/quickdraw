# frozen_string_literal: true

class GreenDots::Run
	def initialize
		@successes = 0
	end

	attr_reader :successes

	def success!
		@successes += 1
		::Kernel.print "\e[32m⚬\e[0m"
	end

	def failure!(message)
		raise(GreenDots::TestFailure, message)
	end
end
