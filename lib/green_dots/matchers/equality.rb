# frozen_string_literal: true

module GreenDots::Matchers::Equality
	def ==(other)
		assert(value == other) { "Expected `#{value.inspect}` to == `#{other.inspect}`." }
	end

	def !=(other)
		assert(value != other) { "Expected `#{value.inspect}` to != `#{other.inspect}`." }
	end
end
