# frozen_string_literal: true

require "zeitwerk"

module GreenDots
	Null = Object.new
	Loader = Zeitwerk::Loader.for_gem.tap(&:setup)
	CONFIGURATION = Configuration.new

	module Error; end

	class TestFailure < RuntimeError
		include Error
	end

	class ArgumentError < ::ArgumentError
		include Error
	end

	def self.configure
		yield CONFIGURATION
	end
end
