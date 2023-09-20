# frozen_string_literal: true

class GreenDots::Result
	def initialize
		@successes = Concurrent::Array.new
		@failures = Concurrent::Array.new
	end

	attr_reader :successes, :failures

	def success!(name)
		@successes << [name]

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
