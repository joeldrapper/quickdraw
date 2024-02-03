# frozen_string_literal: true

module Quickdraw::Matchers::Change
	def to_change(from: Quickdraw::Null, to: Quickdraw::Null, by: Quickdraw::Null, &object)
		original = object.call

		if Quickdraw::Null != from
			assert from === original do
				"expected `#{original.inspect}` to be `#{from.inspect}`"
			end
		end

		block.call

		new = object.call

		if new == original
			failure! "expected `#{original.inspect}` to change"
		end

		if Quickdraw::Null != to
			assert to === new do
				"expected `#{new.inspect}` to be `#{to.inspect}`"
			end
		end

		if Quickdraw::Null != by
			assert by === (new - original) do
				"expected `#{new.inspect}` to change by `#{by.inspect}`"
			end
		end
	end
end
