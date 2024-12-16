# frozen_string_literal: true

class Quickdraw::Test
	include Quickdraw::Assertions

	def self.test(description = nil, skip: false, &block)
		$quickdraw_runner << [self, description, skip, block]
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

		nil
	end

	def refute(value)
		if !value
			success!
		elsif block_given?
			failure! { yield(value) }
		else
			failure! { "expected #{value.inspect} to be falsy" }
		end

		nil
	end

	# Indicate that an assertion passed successfully.
	def success!
		if @skip
			@runner.failure! { "The skipped test `#{@description}` started passing." }
		else
			@runner.success!(@description)
		end

		nil
	end

	# Indicate that an assertion failed.
	def failure!(&)
		if @skip
			@runner.success!(@description)
		else
			@runner.failure!({
				location: @block.source_location,
				description: @description,
				message: yield,
				caller_locations:,
			})
		end

		nil
	end

	def setup = nil
	def teardown = nil
	def around_test = yield
end
