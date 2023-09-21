# frozen_string_literal: true

module GreenDots::Matchers::Boolean
	def to_be_truthy
		assert(value) { "expected `#{value.inspect}` to be truthy" }
	end

	def to_be_falsy
		refute(value) { "expected `#{value.inspect}` to be falsy" }
	end
end
