# frozen_string_literal: true

class Quickdraw::Runner
	def initialize(queue = nil)
		@queue = queue

		@duration = nil
		@successes = []
		@failures = []
	end

	def call
		@duration = Quickdraw::Timer.time do
			@queue.drain { |(f, t)| t.run(self, [f]) }
		end

		[@duration.to_s, @successes, @failures]
	end

	def success!(name)
		@successes << [name]

		Kernel.print(
			Quickdraw::Config.success_symbol
		)
	end

	def failure!(path, &message)
		location = caller_locations.drop_while { |l| !l.path.include?(".test.rb") }

		@failures << [message, location, path]

		Kernel.print(
			Quickdraw::Config.failure_symbol
		)
	end
end
