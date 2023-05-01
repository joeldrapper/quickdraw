# frozen_string_literal: true

module GreenDots::Matchers
	module ToBeA
		def to_be_a(type)
			assert(value.is_a?(type)) { "Expected `#{value.inspect}` to have the type `#{type.inspect}`." }
		end

		alias_method :to_be_an, :to_be_a

		def to_not_be_a(type)
			refute(value.is_a?(type)) { "Expected `#{value.inspect}` to not have the type `#{type.inspect}`." }
		end

		alias_method :to_not_be_an, :to_not_be_a
	end
end
