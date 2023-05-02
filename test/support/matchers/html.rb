# frozen_string_literal: true

require "nokolexbor"

module Matchers::HTML
	def to_have_selector(selector, &block)
		assert value.css(selector).any?(&block) do
			"Expected `#{value.inspect}` to have the selector `#{selector}`."
		end
	end

	def not_to_have_selector(selector, &block)
		refute value.css(selector).any?(&block) do
			"Expected `#{value.inspect}` to not have the selector `#{selector}`."
		end
	end
end
