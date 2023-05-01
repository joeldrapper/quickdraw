# frozen_string_literal: true

module GreenDots::Matchers::TruthyFalsy
	def to_be_truthy
		assert(value) { "Expected `#{value.inspect}` to be truthy." }
	end

	def to_be_falsy
		refute(value) { "Expected `#{value.inspect}` to be falsy." }
	end
end
