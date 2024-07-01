# frozen_string_literal: true

module Quickdraw::Matchers::Include
	def to_include(other)
		assert @subject.include?(other) do
			"expected `#{@subject.inspect}` to include? `#{other.inspect}`"
		end
	end

	def not_to_include(other)
		refute @subject.include?(other) do
			"expected `#{@subject.inspect}` to not include? `#{other.inspect}`"
		end
	end
end
