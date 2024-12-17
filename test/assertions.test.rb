# frozen_string_literal: true

class Runner
	def initialize
		@failures = []
		@successes = 0
	end

	attr_reader :failures, :successes

	def failure!(failure)
		@failures << failure
	end

	def success!(description)
		@successes += 1
	end
end

test "the truth" do
	assert_equal "Hello", "Joel"
end

test "assert_equal" do
	assert_equal 1, 1
end

test "assert_raises" do
	error = assert_raises(ArgumentError) do
		raise ArgumentError.new("Test")
	end

	match { error => ArgumentError }
	assert_equal error.message, "Test"

	assert_test_fails do
		assert_raises(ArgumentError) do
			raise "Test"
		end
	end

	assert_test_fails do
		assert_raises(ArgumentError) {}
	end
end

def assert_test_fails(description = nil, skip: false, &block)
	runner = Runner.new

	Quickdraw::Test.new(description:, skip:, block:).run(runner)

	assert(runner.failures.any?) do
		"expected test to fail"
	end

	runner
end

def assert_test_passes(description = nil, skip: false, &block)
	runner = Runner.new

	Quickdraw::Test.new(description:, skip:, block:).run(runner)

	refute(runner.failures.any? && runner.successes > 0) do
		"expected test to pass"
	end

	runner
end
