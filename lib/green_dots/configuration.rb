# frozen_string_literal: true

class GreenDots::Configuration
	def initialize
		@registry = GreenDots::Registry.new
	end

	attr_reader :registry

	def matcher(matcher, *types)
		@registry.register(matcher, *types)
	end
end
