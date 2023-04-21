# frozen_string_literal: true

class GreenDots::Expectation
	def initialize(context, value = GreenDots::Null, &block)
		if block && GreenDots::Null != value
			raise ::ArgumentError, "You can only provide a value or a block to `expect`."
		end

		@context = context
		@value = value
		@block = block
	end

	def resolve
		if @result.nil?
			failure! { "You didn't make any expectations." }
		end
	end

	def success!
		@context.success!
		@result = true
	end

	def failure!
		@context.failure!(yield)
		@result = false
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

	def assert(value, &block)
		value ? success! : failure!(&block)
	end

	def refute(value, &block)
		value ? failure!(&block) : success!
	end
end
