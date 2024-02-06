# frozen_string_literal: true

class Quickdraw::Runner
	def initialize(tests = nil)
		@tests = tests

		@successes = []
		@failures = []
	end

	attr_reader :successes, :failures, :duration

	def call
		@duration = Quickdraw::Timer.time do
			@tests.drain { |(f, t)| t.run(self, [f]) }
		end
	end

	def success!(name)
		@successes << [name]

		Kernel.print "🟢 "
		# ::Kernel.print "\e[32m⚬\e[0m"
	end

	def failure!(path, &message)
		location = caller_locations.drop_while { |l| !l.path.include?(".test.rb") }

		@failures << [message, location, path]

		Kernel.print "🔴 "
		# ::Kernel.print "\e[31m⚬\e[0m"
	end
end
