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
				@errors = []
			end

			attr_reader :successes, :failures, :errors

			def success!(name, depth: 0)
				@successes << name
			end

			def failure!(name, depth: 0)
				location = caller_locations(2 + depth, 1).first
				@failures << [name, location.path, location.lineno, yield]
			end

			def error!(name, error)
				message = error.respond_to?(:detailed_message) ? error.detailed_message : error.message
				@errors << [name, error.class.name, message, error.backtrace]
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

			assert result.failures.empty?, depth: 3 do
				"expected the test to pass, but it failed"
			end

			assert result.errors.empty?, depth: 3 do
				error = result.errors.first
				<<~MSG
					expected the test to fail but an error occurred:
					#{error[0]}: #{error[1]}
					#{error[2].join("\n\t")}
				MSG
			end

			assert result.successes.length > 0, depth: 3 do
				"expected the test to pass but no assertions were made"
			end
		end

		def to_error
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

			assert result.failures.empty?, depth: 3 do
				"expected the test to error, but it failed"
			end

			refute result.errors.empty?, depth: 3 do
				"expected the test to error"
			end
		end

		def to_fail(message: nil, location: nil)
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

			assert result.errors.empty?, depth: 3 do
				name, cls, msg, bt = result.errors.first
				<<~MSG
					expected the test to fail but a #{cls} occurred in #{name.inspect}:
					#{msg}
					#{bt.join("\n\t")}
				MSG
			end
			assert result.failures.length > 0, depth: 3 do
				"expected the test to fail"
			end

			name, file, line, msg = result.failures.first
			assert(file == location[0], depth: 3) { "expected file #{file.inspect} to be #{location[0].inspect}" } if location
			assert(line == location[1], depth: 3) { "expected line #{line.inspect} to be #{location[1].inspect}" } if location
			assert(message === msg, depth: 3) { "expected message #{msg.inspect} to be #{message.inspect}" } if message
		end
	end
end
