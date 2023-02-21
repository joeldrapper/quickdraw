# frozen_string_literal: true

module Matchers
	def respond_to?(method_name)
		assert @expression.respond_to?(method_name),
			message: "Expected #{@expression} to respond to #{method_name}."
	end
end
