# frozen_string_literal: true

module GreenDots::Matchers::CaseEquality
	def ===(other)
		assert value === other do
			"expected `#{value.inspect}` to === `#{other.inspect}`"
		end
	end
end
