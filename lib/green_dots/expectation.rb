# frozen_string_literal: true

require_relative "matchers/equality"
require_relative "matchers/to_raise"
require_relative "matchers/to_not_raise"
require_relative "matchers/to_receive"
require_relative "matchers/truthy"
require_relative "matchers/falsy"

# < BasicObject
class GreenDots::Expectation
	include GreenDots::Matchers::Falsy
	include GreenDots::Matchers::Truthy
	include GreenDots::Matchers::ToRaise
	include GreenDots::Matchers::Equality
	include GreenDots::Matchers::ToReceive
	include GreenDots::Matchers::ToNotRaise

	def initialize(context, expression = nil, &block)
		if expression && block
			raise ::ArgumentError, "You can only provide an expression or a block to `expect`."
		end

		@context = context
		@expression = expression
		@block = block
	end

	def success!
		@result = true
	end

	def resolve
		case @result
		when nil
			@context.error! "You didn't make any expectations."
		when true
			@context.success!
		else
			@context.error!(@result)
		end
	end

	private

	def expression
		if @block
			raise ArgumentError,
				"You must pass an expression rather than a block when using the #{caller_locations.first.label} matcher."
		else
			@expression
		end
	end

	def block
		@block || raise(ArgumentError,
			"You must pass a block rather than an expression when using the #{caller_locations.first.label} matcher.")
	end

	def assert(expression)
		expression ? success! : @result = yield
	end

	def refute(expression)
		expression ? @result = yield : success!
	end
end
