# frozen_string_literal: true

module Matchers
	module PassFail
		class Result
			def initialize
				@successes = Concurrent::Array.new
				@failures = Concurrent::Array.new
			end

			attr_reader :successes, :failures

			def success!(name)
				@successes << name
			end

			def failure!(path)
				@failures << yield
			end
		end

		def to_pass
			begin
				Class.new(GreenDots::Context, &block).run(Result.new)
			rescue GreenDots::TestFailure
				return failure! { "expected the test to pass" }
			end

			success!
		end

		def to_fail(message: nil)
			result = Result.new
			Class.new(GreenDots::Context, &block).run(result)

			assert result.failures.any? do
				"expected the test to fail"
			end

			if message
				assert result.failures.include?(message) do
					"expected the test to fail with message: #{message.inspect}"
				end
			end
		end
	end
end
