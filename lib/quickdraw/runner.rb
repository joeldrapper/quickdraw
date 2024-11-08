# frozen_string_literal: true

require "json"

class Quickdraw::Runner
	def initialize(queue:, threads:)
		@queue = queue
		@threads = threads

		@failures = Concurrent::Array.new
		@successes = Concurrent::Array.new
		@errors = Concurrent::Array.new
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
			"errors" => @errors.to_a,
		}
	end

	def success!(name, depth: 0)
		@successes << name

		Kernel.print(
			Quickdraw::Config.success_symbol,
		)
	end

	def failure!(name, depth: 0)
		location = caller_locations(2 + depth, 1).first
		@failures << [name, location.path, location.lineno, yield]

		Kernel.print(
			Quickdraw::Config.failure_symbol,
		)
	end

	def error!(name, error)
		message = error.respond_to?(:detailed_message) ? error.detailed_message : error.message
		@errors << [name, error.class.name, message, error.backtrace]

		Kernel.print(
			Quickdraw::Config.error_symbol,
		)
	end

	private

	def drain_queue
		queue = @queue
		next_item = queue.shift

		while next_item
			name, skip, test, context = next_item
			context.run_test(name, skip, self, &test)
			next_item = queue.shift
		end
	end
end
