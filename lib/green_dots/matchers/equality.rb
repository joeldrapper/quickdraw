# frozen_string_literal: true

module GreenDots::Matchers
	module Equality
		def ==(other)
			assert(expression == other) { "Expected #{expression.inspect} to == #{other.inspect}." }
		end

		def !=(other)
			assert(expression != other) { "Expected #{expression.inspect} to != #{other.inspect}." }
		end
	end
end
