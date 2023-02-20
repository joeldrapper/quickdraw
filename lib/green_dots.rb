# frozen_string_literal: true

require_relative "green_dots/version"

module GreenDots
	def self.success
		::Kernel.print "\e[32m·\e[0m"
	end

	# @yield [example]
	# @yieldparam example [GreenDots::Example]
	def self.describe(*description, &block)
		Class.new(GreenDots::Example, &block).run
	end
end

require_relative "green_dots/example"
require_relative "green_dots/expectation"
