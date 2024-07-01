# frozen_string_literal: true

module Quickdraw::Matchers::Predicate
	def to_be(predicate)
		assert @subject.public_send(predicate) do
			"expected `#{@subject.inspect}` to be `#{predicate.inspect}`"
		end
	end

	def not_to_be(predicate)
		refute @subject.public_send(predicate) do
			"expected `#{@subject.inspect}` to not be `#{predicate.inspect}`"
		end
	end

	alias_method :to_have, :to_be
	alias_method :not_to_have, :not_to_be
end
