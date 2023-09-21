# frozen_string_literal: true

class GreenDots::Result
	def self.call(batch)
		tests = batch.map do |f|
			Class.new(GreenDots::Context) do
				class_eval(
					File.read(f), f, 1
				)
			end
		end

		new(tests).tap(&:call)
	end

	def initialize(tests = nil)
		@tests = tests

		@successes = Concurrent::Array.new
		@failures = Concurrent::Array.new
	end

	attr_reader :successes, :failures, :elapsed_time

	def call
		@elapsed_time = GreenDots.timer do
			@tests.each { |t| t.run(self) }
		end
	end

	def success!(name)
		@successes << [name]

		Kernel.print "🟢 "
		# ::Kernel.print "\e[32m⚬\e[0m"
	end

	def failure!(&message)
		location = caller_locations.drop_while { |l| !l.path.include?(".test.rb") }

		@failures << [message, location]

		Kernel.print "🔴 "
		# ::Kernel.print "\e[31m⚬\e[0m"
	end
end
