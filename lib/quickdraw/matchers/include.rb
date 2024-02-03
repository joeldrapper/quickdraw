# frozen_string_literal: true

module Quickdraw::Matchers::Include
	def to_include(other)
		assert value.include?(other) do
			"expected `#{value.inspect}` to include? `#{other.inspect}`"
		end
	end

	def not_to_include(other)
		refute value.include?(other) do
			"expected `#{value.inspect}` to not include? `#{other.inspect}`"
		end
	end
end
