# frozen_string_literal: true

module GreenDots::Matchers::Predicate
	def to_be(predicate)
		assert(value.send(predicate)) { "expected `#{value.inspect}` to be `#{predicate.inspect}`" }
	end

	def not_to_be(predicate)
		refute(value.send(predicate)) { "expected `#{value.inspect}` to not be `#{predicate.inspect}`" }
	end

	alias_method :to_have, :to_be
	alias_method :not_to_have, :not_to_be
end
