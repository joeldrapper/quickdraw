# frozen_string_literal: true

require "zeitwerk"
require "concurrent"

module GreenDots
	Null = Object.new.freeze
	Loader = Zeitwerk::Loader.for_gem.tap(&:setup)
	Config = Configuration.new

	module Error; end

	class TestFailure < RuntimeError
		include Error
	end

	class ArgumentError < ::ArgumentError
		include Error
	end

	def self.configure(&block)
		if block.arity == 0
			Config.instance_eval(&block)
		else
			yield Config
		end
	end
end
