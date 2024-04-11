# frozen_string_literal: true

class Quickdraw::Context
	DEFAULT_MATCHERS = [
		Quickdraw::Matchers::Boolean,
		Quickdraw::Matchers::CaseEquality,
		Quickdraw::Matchers::Change,
		Quickdraw::Matchers::Equality,
		Quickdraw::Matchers::Include,
		Quickdraw::Matchers::Predicate,
		Quickdraw::Matchers::RespondTo,
		Quickdraw::Matchers::ToBeA,
		Quickdraw::Matchers::ToHaveAttributes,
		Quickdraw::Matchers::ToRaise,
		Quickdraw::Matchers::ToReceive
	].freeze

	class << self
		def describe(description, &)
			Class.new(self, &)
		end

		def test(name = nil, skip: false, &block)
			run << [name, skip, block, self]
		end

		def use(*new_matchers)
			i = 0
			number_of_new_matchers = new_matchers.size

			while i < number_of_new_matchers
				matchers << new_matchers[i]
				i += 1
			end
		end

		def matchers
			@matchers ||= if superclass < Quickdraw::Context
				superclass.matchers.dup
			else
				Set.new(DEFAULT_MATCHERS)
			end
		end

		def init(name, skip)
			new(name, skip, run, matchers)
		end
	end

	def initialize(name, skip, run, matchers)
		@name = name
		@skip = skip
		@run = run
		@matchers = matchers

		@expectations = []
	end

	def expect(value = Quickdraw::Null, &block)
		type = Quickdraw::Null == value ? block : value
		expectation = expectation_for(type).new(self, value, &block)
		@expectations << expectation
		expectation
	end

	private def expectation_for(type)
		Quickdraw::Config.registry.expectation_for(
			type,
			matchers: @matchers
		)
	end

	def resolve
		i = 0
		expectations_size = @expectations.size

		while i < expectations_size
			@expectations[i].resolve
			i += 1
		end
	ensure
		@expectations.clear
	end

	def assert(value)
		if value
			success!
		elsif block_given?
			failure! { yield(value) }
		else
			failure! { "expected #{value.inspect} to be truthy" }
		end
	end

	def refute(value)
		if !value
			success!
		elsif block_given?
			failure! { yield(value) }
		else
			failure! { "expected #{value.inspect} to be falsy" }
		end
	end

	def success!
		if @skip
			@run.failure! { "The skipped test `#{@name}` started passing." }
		else
			@run.success!(@name)
		end
	end

	def failure!(&)
		if @skip
			@run.success!(@name)
		else
			@run.failure!(&)
		end
	end
end
