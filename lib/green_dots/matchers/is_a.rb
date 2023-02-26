# frozen_string_literal: true

module GreenDots::Matchers
	module IsA
		def is_a?(type)
			assert expression.is_a?(type) do
				"Expected #{expression.inspect} to have the type #{type.inspect}"
			end
		end
	end
end
