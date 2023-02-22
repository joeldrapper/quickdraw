# frozen_string_literal: true

require_relative "green_dots/version"

module GreenDots
	class TestFailure < RuntimeError; end

	module Context
		def describe(description = nil, &block)
			Class.new(GreenDots::Test, &block).run
		end

		alias_method :context, :describe

		def test(name = nil, skip: false, &block)
			{
				name: name,
				block: block,
				skip: skip
			}.tap { (@tests ||= []) << _1 }
		end
	end

	def self.success
		::Kernel.print "\e[32m·\e[0m"
	end
end

require_relative "green_dots/test"
require_relative "green_dots/expectation"
