# frozen_string_literal: true

class GreenDots::Configuration
	def initialize
		@registry = GreenDots::Registry.new
	end

	attr_reader :registry

	def register_matcher(...)
		@registry.register(...)
	end
end
