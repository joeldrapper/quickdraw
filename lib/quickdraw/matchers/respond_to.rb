# frozen_string_literal: true

module Quickdraw::Matchers::RespondTo
	def to_respond_to(method)
		assert value.respond_to?(method) do
			"expected `#{value.inspect}` to respond to `#{method.inspect}`"
		end
	end

	def not_to_respond_to(method)
		refute value.respond_to?(method) do
			"expected `#{value.inspect}` to not respond to `#{method.inspect}`"
		end
	end
end
