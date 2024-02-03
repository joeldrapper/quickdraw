# frozen_string_literal: true

class Quickdraw::Expectation
	def initialize(context, value = Quickdraw::Null, &block)
		if block && Quickdraw::Null != value
			raise Quickdraw::ArgumentError.new(
				"You must only provide a value or a block to `expect`."
			)
		end

		@context = context
		@value = value
		@block = block
		@made_expectations = false
	end

	def success!
		@context.success!
		@made_expectations = true
	end

	def failure!(&)
		@context.failure!(&)
		@made_expectations = true
	end

	def resolve
		if !@made_expectations
			failure! { "You didn't make any expectations." }
		end
	end

	private

	def assert(value, &)
		value ? success! : failure!(&)
	end

	def refute(value, &)
		value ? failure!(&) : success!
	end

	def value
		if @block
			raise Quickdraw::ArgumentError.new(
				"You must pass a value rather than a block when using the #{caller_locations.first.label} matcher."
			)
		else
			@value
		end
	end

	def block
		if @block
			@block
		else
			raise Quickdraw::ArgumentError.new(
				"You must pass a block rather than a value when using the #{caller_locations.first.label} matcher."
			)
		end
	end
end
