# frozen_string_literal: true

module GreenDots::Matchers::CaseEquality
	def ===(other)
		assert(subject === other) { "Expected `#{subject.inspect}` to === `#{other.inspect}`." }
	end
end
