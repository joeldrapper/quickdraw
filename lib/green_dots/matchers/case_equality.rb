# frozen_string_literal: true

module GreenDots::Matchers::CaseEquality
	def ===(other)
		assert(value === other) { "Expected `#{value.inspect}` to === `#{other.inspect}`." }
	end
end
