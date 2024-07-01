# frozen_string_literal: true

module Matchers
	module PassFail
		class Run
			def initialize
				@tests = []
			end

			attr_reader :tests

			def <<(test)
				@tests << test
			end
		end

		class Result
			def initialize
				@successes = []
				@failures = []
			end

			attr_reader :successes, :failures

			def success!(name)
				@successes << name
			end

			def failure!
				@failures << yield
			end
		end

		def to_pass
			run = Run.new
			result = Result.new
			definition = @block

			Class.new(Quickdraw::Context) do
				define_singleton_method(:run) { run }
				class_exec(&definition)
			end

			run.tests.each do |(name, skip, test, context)|
				context.run_test(name, skip, result, &test)
			end

			assert result.failures.empty? do
				"expected the test to pass, but it failed"
			end

			assert result.successes.length > 0 do
				"expected the test to pass but no assertions were made"
			end
		end

		def to_fail(message: nil)
			run = Run.new
			result = Result.new
			definition = @block

			Class.new(Quickdraw::Context) do
				define_singleton_method(:run) { run }
				class_exec(&definition)
			end

			run.tests.each do |(name, skip, test, context)|
				context.run_test(name, skip, result, &test)
			end

			assert result.failures.length > 0 do
				"expected the test to fail"
			end
		end
	end
end
