# frozen_string_literal: true

class GreenDots::SomeRunner
	def initialize(writer, batch, result, index)
		@writer = writer
		@batch = batch
		@result = result
		@index = index
	end

	attr_reader :batch, :writer, :result, :index

	def call
		batch_elapsed_time = GreenDots.timer do
			batch.each do |f|
				Class.new(GreenDots::Context) do
					class_eval(
						File.read(f), f, 1
					)
				end.run(result)
			end
		end

		writer.write("Process[#{index + 1}]: #{result.successes} assertions passed in #{batch_elapsed_time} milliseconds. #{SUCCESS_EMOJI.sample}")
		result.failures.each do |(message, backtrace)|
			writer.write "\n\n"
			writer.write message
			writer.write "\n"
			writer.write "#{backtrace.first.path}:#{backtrace.first.lineno}"
		end
	end
end
