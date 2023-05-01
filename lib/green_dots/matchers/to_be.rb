# frozen_string_literal: true

module GreenDots::Matchers::ToBe
	def to_be(predicate)
		assert(value.send(predicate)) { "Expected `#{value.inspect}` to be `#{predicate}`." }
	end

	alias_method :to_have, :to_be

	def to_not_be(predicate)
		refute(value.send(predicate)) { "Expected `#{value.inspect}` to not be `#{predicate}`." }
	end

	alias_method :to_not_have, :to_not_be
end
