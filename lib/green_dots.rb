# frozen_string_literal: true

require "zeitwerk"

module GreenDots
	Loader = Zeitwerk::Loader.for_gem.tap(&:setup)

	EXPECTATION_SHAPES = {}

	module Error; end

	class TestFailure < RuntimeError
		include Error
	end

	class ArgumentError < ::ArgumentError
		include Error
	end
end
