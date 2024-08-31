# frozen_string_literal: true

class Quickdraw::Expectation
	NEVER_BLOCK = Quickdraw::Never.new("You must pass a block rather than a subject.")
	NEVER_SUBJECT = Quickdraw::Never.new("You must pass a subject rather than a block.")

	include Quickdraw::Matchers::Boolean
	include Quickdraw::Matchers::Change
	include Quickdraw::Matchers::Equality
	include Quickdraw::Matchers::Include
	include Quickdraw::Matchers::Predicate
	include Quickdraw::Matchers::RespondTo
	include Quickdraw::Matchers::ToBeA
	include Quickdraw::Matchers::ToHaveAttributes
	include Quickdraw::Matchers::ToRaise
	include Quickdraw::Matchers::ToReceive

	def initialize(context, subject = Quickdraw::Null, &block)
		if block
			if Quickdraw::Null != subject
				raise Quickdraw::ArgumentError.new("You must only provide a subject or a block to `expect`.")
			end
		elsif Quickdraw::Null == subject
			raise Quickdraw::ArgumentError.new("You must provide a subject or a block to `expect`.")
		end

		@context = context

		if Quickdraw::Null == subject
			@subject = NEVER_SUBJECT
			@block = block
		else
			@subject = subject
			@block = NEVER_BLOCK
		end

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
		unless @made_expectations
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
end
