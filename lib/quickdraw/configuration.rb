# frozen_string_literal: true

class Quickdraw::Configuration
	def initialize
		@registry = Quickdraw::Registry.new
		@failure_symbol = "🔴"
		@success_symbol = "🟢"
	end

	attr_reader :registry, :failure_symbol, :success_symbol

	def matcher(matcher, *types)
		@registry.register(matcher, *types)
	end
end
