# frozen_string_literal: true

module GreenDots::Matchers::ToBeA
	def to_be_a(type)
		assert type === value do
			"expected `#{value.inspect}` to have the type `#{type.inspect}`"
		end
	end

	def not_to_be_a(type)
		refute type === value do
			"expected `#{value.inspect}` to not have the type `#{type.inspect}`"
		end
	end

	alias_method :to_be_an, :to_be_a
	alias_method :not_to_be_an, :not_to_be_a
end
