# frozen_string_literal: true

module GreenDots::Matchers::Predicate
	def to_be(predicate)
		assert(subject.send(predicate)) { "Expected `#{subject.inspect}` to be `#{predicate.inspect}`." }
	end

	alias_method :to_have, :to_be

	def not_to_be(predicate)
		refute(subject.send(predicate)) { "Expected `#{subject.inspect}` to not be `#{predicate.inspect}`." }
	end

	alias_method :not_to_have, :not_to_be
end
