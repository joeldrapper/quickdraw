# frozen_string_literal: true

require_relative "matchers/equality"
require_relative "matchers/to_raise"
require_relative "matchers/to_not_raise"
require_relative "matchers/to_receive"
require_relative "matchers/truthy"
require_relative "matchers/falsy"
require_relative "matchers/is_a"

# < BasicObject
class GreenDots::Expectation
	include GreenDots::Matchers::IsA
	include GreenDots::Matchers::Falsy
	include GreenDots::Matchers::Truthy
	include GreenDots::Matchers::ToRaise
	include GreenDots::Matchers::Equality
	include GreenDots::Matchers::ToReceive
	include GreenDots::Matchers::ToNotRaise

	def initialize(context, value = nil, &block)
		if value && block
			raise ::ArgumentError, "You can only provide a value or a block to `expect`."
		end

		@context = context
		@value = value
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

	def value
		if @block
			raise GreenDots::ArgumentError,
				"You must pass a value rather than a block when using the #{caller_locations.first.label} matcher."
		else
			@value
		end
	end

	def block
		@block || raise(GreenDots::ArgumentError,
			"You must pass a block rather than a value when using the #{caller_locations.first.label} matcher.")
	end

	def assert(value)
		value ? success! : error!(yield)
	end

	def refute(value)
		value ? error!(yield) : success!
	end

	def error!(message)
		@context.error!(message)
	end
end
