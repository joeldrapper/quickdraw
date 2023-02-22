# frozen_string_literal: true

module GreenDots::Matchers
	module Equality
		def ==(other)
			assert(expression == other) { "Expected #{expression} to == #{other}." }
		end

		def !=(other)
			assert(expression != other) { "Expected #{expression} to != #{other}" }
		end
	end
end
