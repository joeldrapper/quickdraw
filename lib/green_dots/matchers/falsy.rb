# frozen_string_literal: true

module GreenDots::Matchers
	module Falsy
		def falsy?
			refute(expression) { "Expected #{expression.inspect} to be falsy." }
		end
	end
end
