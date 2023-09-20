# frozen_string_literal: true

module GreenDots::Matchers::CaseEquality
	def ===(other)
		assert value === other do
			"Expected `#{value.inspect}` to === `#{other.inspect}`."
		end
	end
end
