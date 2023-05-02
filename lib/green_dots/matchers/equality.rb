# frozen_string_literal: true

module GreenDots::Matchers::Equality
	def ==(other)
		assert(subject == other) { "Expected `#{subject.inspect}` to == `#{other.inspect}`." }
	end

	def !=(other)
		assert(subject != other) { "Expected `#{subject.inspect}` to != `#{other.inspect}`." }
	end
end
