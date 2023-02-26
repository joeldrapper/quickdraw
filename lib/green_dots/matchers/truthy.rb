# frozen_string_literal: true

module GreenDots::Matchers
	module Truthy
		def truthy?
			assert(expression) { "Expected #{expression.inspect} to be truthy." }
		end
	end
end
