# frozen_string_literal: true

module GreenDots::Matchers::Change
	def to_change(from: GreenDots::Null, to: GreenDots::Null, by: GreenDots::Null, &object)
		original = object.call

		if GreenDots::Null != from
			assert from === original do
				"Expected `#{original.inspect}` to be `#{from.inspect}`."
			end
		end

		block.call

		new = object.call

		if new == original
			failure! "Expected `#{original.inspect}` to change."
		end

		if GreenDots::Null != to
			assert to === new do
				"Expected `#{new.inspect}` to be `#{to.inspect}`."
			end
		end

		if GreenDots::Null != by
			assert by === (new - original) do
				"Expected `#{new.inspect}` to change by `#{by.inspect}`."
			end
		end
	end
end
