# frozen_string_literal: true

class Quickdraw::Test
	def self.test(description = nil, skip: false, &block)
		# An Array is used here for performance, since arrays are very cheap to allocate. Allocating a Test object is deferred until running the test later on, when the allocations can be parallelized.
		$quickdraw_runner << [description, skip, block]
	end

	def initialize(description:, skip:, block:)
		@description = description
		@skip = skip
		@block = block
		@runner = nil
	end

	def run(runner)
		@runner = runner
		setup
		around_test { instance_exec(&@block) }
		teardown
	end

	def match
		yield
		success!
	rescue Exception => e
		failure! { e.message }
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

	# Indicate that an assertion passed successfully.
	def success!
		if @skip
			@runner.failure! { "The skipped test `#{@description}` started passing." }
		else
			@runner.success!(@description)
		end
	end

	# Indicate that an assertion failed.
	def failure!(&)
		if @skip
			@runner.success!(@description)
		else
			@runner.failure!(&)
		end
	end

	def setup = nil
	def teardown = nil
	def around_test = yield
end
