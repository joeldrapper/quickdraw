# frozen_string_literal: true

class Quickdraw::Configuration
	def initialize
		@registry = Quickdraw::Registry.new
	end

	attr_reader :registry

	def matcher(matcher, *types)
		@registry.register(matcher, *types)
	end
end
