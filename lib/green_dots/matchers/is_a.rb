# frozen_string_literal: true

module GreenDots::Matchers
	module IsA
		def is_a?(type)
			assert value.is_a?(type) do
				"Expected #{value.inspect} to have the type #{type.inspect}"
			end
		end
	end
end
