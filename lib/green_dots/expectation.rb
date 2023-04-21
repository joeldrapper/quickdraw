# frozen_string_literal: true

class GreenDots::Expectation
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
			@context.failure! "You didn't make any expectations."
		when true
			@context.success!
		else
			@context.failure!(@result)
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
		value ? success! : failure!(yield)
	end

	def refute(value)
		value ? failure!(yield) : success!
	end

	def failure!(message)
		@context.failure!(message)
	end
end
