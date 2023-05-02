# frozen_string_literal: true

require "nokolexbor"

module Matchers::HTML
	def to_have_selector(selector, &block)
		assert subject.css(selector).any?(&block) do
			"Expected `#{subject.inspect}` to have the selector `#{selector}`."
		end
	end

	def not_to_have_selector(selector, &block)
		refute subject.css(selector).any?(&block) do
			"Expected `#{subject.inspect}` to not have the selector `#{selector}`."
		end
	end
end
