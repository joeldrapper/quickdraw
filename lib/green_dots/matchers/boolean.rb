# frozen_string_literal: true

module GreenDots::Matchers::Boolean
	def to_be_truthy
		assert(subject) { "Expected `#{subject.inspect}` to be truthy." }
	end

	def to_be_falsy
		refute(subject) { "Expected `#{subject.inspect}` to be falsy." }
	end
end
