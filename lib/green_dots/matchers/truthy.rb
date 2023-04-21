# frozen_string_literal: true

module GreenDots::Matchers
	module Truthy
		def truthy?
			assert(value) { "Expected #{value.inspect} to be truthy." }
		end
	end
end
