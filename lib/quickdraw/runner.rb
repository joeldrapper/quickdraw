# frozen_string_literal: true

require "json"

class Quickdraw::Runner
	def initialize(queue:, threads:)
		@queue = queue
		@threads = threads

		@failures = Concurrent::Array.new
		@successes = Concurrent::Array.new
	end

	def call
		results = Array.new(@threads) {
			Thread.new {
				drain_queue
			}
		}

		results.each(&:join)

		{
			"pid" => Process.pid,
			"failures" => @failures.to_a,
			"successes" => @successes.size,
		}
	end

	def success!(name)
		@successes << name

		Kernel.print(
			Quickdraw::Config.success_symbol,
		)
	end

	def failure!
		location = caller_locations(3, 1).first
		@failures << [location.path, location.lineno, yield]

		Kernel.print(
			Quickdraw::Config.failure_symbol,
		)
	end

	private

	def drain_queue
		@queue.drain { |(name, skip, test, context)|
			context.run_test(name, skip, self, &test)
		}
	end
end
