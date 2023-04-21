# frozen_string_literal: true

require_relative "green_dots/version"

module GreenDots
	EXPECTATION_SHAPES = {}

	module Error; end

	class TestFailure < RuntimeError
		include Error
	end

	class ArgumentError < ::ArgumentError
		include Error
	end

	def self.success
		# ::Kernel.print "\e[32m◦\e[0m"
		::Kernel.print "\e[32m⚬\e[0m"
	end
end

require_relative "green_dots/context"
require_relative "green_dots/test"
require_relative "green_dots/expectation"
