# frozen_string_literal: true

class GreenDots::Expectation
	def initialize(context, subject = GreenDots::Null, &block)
		if block && GreenDots::Null != subject
			raise GreenDots::ArgumentError, "You can only provide a subject or a block to `expect`."
		end

		@context = context
		@subject = subject
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

	def subject
		if @block
			raise GreenDots::ArgumentError,
				"You must pass a subject rather than a block when using the #{caller_locations.first.label} matcher."
		else
			@subject
		end
	end

	def block
		@block || raise(GreenDots::ArgumentError,
			"You must pass a block rather than a subject when using the #{caller_locations.first.label} matcher.")
	end

	def assert(subject, &block)
		subject ? success! : failure!(&block)
	end

	def refute(subject, &block)
		subject ? failure!(&block) : success!
	end
end
