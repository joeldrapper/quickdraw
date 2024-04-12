# frozen_string_literal: true

require "json"

class Quickdraw::Runner
	def initialize(queue:, threads:)
		@queue = queue
		@threads = threads

		@failures = Quickdraw::ConcurrentArray.new
		@successes = Quickdraw::ConcurrentArray.new
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
			"successes" => @successes.size
		}
	end

	def success!(name)
		@successes << name

		Kernel.print(
			Quickdraw::Config.success_symbol
		)
	end

	def failure!
		location = caller_locations.drop_while { |it| !it.path.include?(".test.rb") }.first
		@failures << [location.path, location.lineno, yield]

		Kernel.print(
			Quickdraw::Config.failure_symbol
		)
	end

	private def drain_queue
		@queue.drain { |(name, skip, test, context)|
			context.init(name, skip, self).instance_exec(&test)
		}
	end
end
