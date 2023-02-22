# frozen_string_literal: true

module GreenDots::Matchers
	module Falsy
		def falsy?
			refute(expression) { "Expected #{@expression} to be truthy." }
		end
	end
end
