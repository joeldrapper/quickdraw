# frozen_string_literal: true

class Quickdraw::Runner
	def initialize(tests = nil)
		@tests = tests

		@successes = []
		@failures = []
		@duration = nil
	end

	def call
		@duration = Quickdraw::Timer.time do
			@tests.drain { |(f, t)| t.run(self, [f]) }
		end

		result
	end

	def success!(name)
		@successes << [name]

		Kernel.print(
			Quickdraw::CONFIG.success_symbol
		)
	end

	def failure!(path, &message)
		location = caller_locations.drop_while { |l| !l.path.include?(".test.rb") }

		@failures << [message, location, path]

		Kernel.print(
			Quickdraw::CONFIG.failure_symbol
		)
	end

	def result
		[
			@duration,
			@successes,
			@failures
		]
	end
end
