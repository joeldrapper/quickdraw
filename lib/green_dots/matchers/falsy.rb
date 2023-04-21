# frozen_string_literal: true

module GreenDots::Matchers
	module Falsy
		def falsy?
			refute(value) { "Expected #{value.inspect} to be falsy." }
		end
	end
end
