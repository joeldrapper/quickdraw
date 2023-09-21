# frozen_string_literal: true

class GreenDots::Result
	# TODO: these shouldn't be optional
	def initialize(writer = nil, batch = nil, index = nil)
		@writer = writer
		@batch = batch
		@index = index

		@successes = Concurrent::Array.new
		@failures = Concurrent::Array.new
	end

	attr_reader :successes, :failures, :batch, :writer, :index

	def call
		batch_elapsed_time = GreenDots.timer do
			batch.each do |f|
				Class.new(GreenDots::Context) do
					class_eval(
						File.read(f), f, 1
					)
				end.run(self)
			end
		end

		writer.write("Process[#{index + 1}]: #{successes} assertions passed in #{batch_elapsed_time} milliseconds. #{SUCCESS_EMOJI.sample}")
		failures.each do |(message, backtrace)|
			writer.write "\n\n"
			writer.write message
			writer.write "\n"
			writer.write "#{backtrace.first.path}:#{backtrace.first.lineno}"
		end
	end

	def success!(name)
		@successes << [name]

		::Kernel.print "\e[32m⚬\e[0m"
	end

	def failure!(message)
		location = caller_locations.lazy
																													.drop_while { |l| !l.path.include?(".test.rb") }
																													.reject { |l| l.path.include?("/green_dots/") }
																													.reject { |l| l.path.include?("/gems/") }

		@failures << [message, location]

		::Kernel.print "\e[31m⚬\e[0m"
	end
end
