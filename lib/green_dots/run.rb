# frozen_string_literal: true

class GreenDots::Run
	def initialize
		@successes = 0
		@failures = Concurrent::Array.new
		@mutex = Mutex.new
	end

	attr_reader :successes, :failures

	def success!
		@mutex.synchronize do
			@successes += 1
		end

		::Kernel.print "\e[32m⚬\e[0m"
	end

	def failure!(message)
		location = caller_locations.lazy
																													.drop_while { |l| !l.path.include?(".test.rb") }
																													.reject { |l| l.path.include?("/green_dots/") }
																													.reject { |l| l.path.include?("/gems/") }

		@failures << [message, location]

		::Kernel.print "\e[31m⚬\e[0m"
	end
end
