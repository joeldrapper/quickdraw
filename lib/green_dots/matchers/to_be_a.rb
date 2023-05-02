# frozen_string_literal: true

module GreenDots::Matchers::ToBeA
	def to_be_a(type)
		assert(subject.is_a?(type)) { "Expected `#{subject.inspect}` to have the type `#{type.inspect}`." }
	end

	alias_method :to_be_an, :to_be_a

	def not_to_be_a(type)
		refute(subject.is_a?(type)) { "Expected `#{subject.inspect}` to not have the type `#{type.inspect}`." }
	end

	alias_method :not_to_be_an, :not_to_be_a
end
