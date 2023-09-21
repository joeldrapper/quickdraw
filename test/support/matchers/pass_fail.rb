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

			def failure!
				@failures << yield
			end
		end

		def to_pass
			begin
				Class.new(GreenDots::Context, &block).run
			rescue GreenDots::TestFailure
				failure! { "Expected the test to pass." }
			end

			success!
		end

		def to_fail(message: nil)
			result = Result.new
			Class.new(GreenDots::Context, &block).run(result)

			assert result.failures.any? do
				"Expected the test to fail."
			end

			if message
				assert result.failures.include?(message) do
					"Expected the test to fail with message: #{message.inspect}"
				end
			end
		end
	end
end
