# frozen_string_literal: true

class GreenDots::Context
	DEFAULT_MATCHERS = [
		GreenDots::Matchers::ToBeA,
		GreenDots::Matchers::Boolean,
		GreenDots::Matchers::ToRaise,
		GreenDots::Matchers::Equality,
		GreenDots::Matchers::ToReceive,
		GreenDots::Matchers::Predicate,
		GreenDots::Matchers::CaseEquality,
		GreenDots::Matchers::ToHaveAttributes
	].freeze

	class << self
		def run(result = GreenDots::Result.new, path = [])
			new(result, path).run(@tests) if @tests

			if defined?(@sub_contexts)
				@sub_contexts.each do |(context, desc)|
					context.run(result, [*path, desc])
				end
			end
		end

		def use(*new_matchers)
			new_matchers.each { |m| matchers << m }
		end

		def matchers
			@matchers ||= if superclass < GreenDots::Context
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

		alias_method :context, :describe

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
		tests.each do |(name, skip, block)|
			@name = name
			@skip = skip

			instance_exec(&block)

			resolve
		end
	end

	def expect(value = GreenDots::Null, &block)
		type = GreenDots::Null == value ? block : value

		expectation_class = GreenDots::Config.registry.expectation_for(
			type, matchers: @matchers
		)

		expectation = expectation_class.new(self, value, &block)
		@expectations << expectation
		expectation
	end

	def resolve
		@expectations.each(&:resolve)
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
