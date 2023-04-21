# frozen_string_literal: true

module GreenDots::Matchers
	module TruthyFalsy
		def truthy?
			assert(value) { "Expected #{value.inspect} to be truthy." }
		end

		def falsy?
			refute(value) { "Expected #{value.inspect} to be falsy." }
		end
	end
end
