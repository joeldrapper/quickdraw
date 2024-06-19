# frozen_string_literal: true

module Quickdraw::Matchers::Predicate
	def to_be(predicate)
		assert value.__send__(predicate) do
			"expected `#{value.inspect}` to be `#{predicate.inspect}`"
		end
	end

	def not_to_be(predicate)
		refute value.__send__(predicate) do
			"expected `#{value.inspect}` to not be `#{predicate.inspect}`"
		end
	end

	alias_method :to_have, :to_be
	alias_method :not_to_have, :not_to_be
end
