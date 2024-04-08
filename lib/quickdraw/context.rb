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
		Quickdraw::Matchers::ToReceive,
	].freeze

	class << self
		def run(result = Quickdraw::Runner.new, path = [])
			new(result, path).run(@tests) if @tests

			if defined?(@sub_contexts)
				i = 0
				sub_contexts_size = @sub_contexts.size

				while i < sub_contexts_size
					context, desc = @sub_contexts[i]
					context.run(result, [*path, desc])
					i += 1
				end
			end
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

		def describe(description, &block)
			unless defined?(@sub_contexts)
				@sub_contexts = []
			end

			@sub_contexts << [Class.new(self, &block), description]
		end

		def test(name = nil, skip: false, &block)
			unless defined?(@tests)
				@tests = []
			end

			@tests << [name, skip, block]
		end
	end

	def initialize(run, path)
		@run = run
		@path = path
		@expectations = []
		@matchers = self.class.matchers

		@name = nil
		@skip = false
	end

	def run(tests)
		i = 0
		tests_size = tests.size

		while i < tests_size
			@name, @skip, block = tests[i]

			instance_exec(&block)

			resolve
			i += 1
		end
	end

	def expect(value = Quickdraw::Null, &block)
		type = Quickdraw::Null == value ? block : value

		expectation_class = Quickdraw::Config.registry.expectation_for(
			type,
			matchers: @matchers
		)

		expectation = expectation_class.new(self, value, &block)
		@expectations << expectation
		expectation
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
			@run.failure!(full_path) { "The skipped test `#{@name}` started passing." }
		else
			@run.success!(@name)
		end
	end

	def failure!(&)
		if @skip
			@run.success!(@name)
		else
			@run.failure!(full_path, &)
		end
	end

	def full_path
		[*@path, @name]
	end
end
