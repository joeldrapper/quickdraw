# frozen_string_literal: true

module Quickdraw::Matchers::RespondTo
	def to_respond_to(method)
		assert @subject.respond_to?(method) do
			"expected `#{@subject.inspect}` to respond to `#{method.inspect}`"
		end
	end

	def not_to_respond_to(method)
		refute @subject.respond_to?(method) do
			"expected `#{@subject.inspect}` to not respond to `#{method.inspect}`"
		end
	end
end
