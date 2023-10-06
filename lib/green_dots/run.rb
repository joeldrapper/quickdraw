# frozen_string_literal: true
require "rouge"

Lexer = Rouge::Lexers::Ruby.new
Formatter = Rouge::Formatters::Terminal256.new(
	theme: Rouge::Themes::Monokai.new
)

class GreenDots::Run
	def initialize(number_of_processes:, directory:, test_files:)
		@number_of_processes = number_of_processes
		@directory = directory
		@test_files = test_files.shuffle

		@cluster = GreenDots::Cluster.new
		@batches = Array.new(@number_of_processes) { [] }

		@test_files.each_with_index do |file, index|
			@batches[index % @number_of_processes] << file
		end
	end

	def call
		report_time do
			load_directory
			require "helper"
			fork_processes
			@results = @cluster.wait
			puts_results
		end
	end

	def report_time(&)
		total_time = GreenDots.timer(&)
		puts "Total time: #{total_time.ms}ms"
	end

	def load_directory
		$LOAD_PATH.unshift File.expand_path("#{@directory}/support")
	end

	def fork_processes
		@batches.each_with_index do |batch, index|
			@cluster.fork do |writer|
				result = GreenDots::Result.call(batch)

				writer.write("Process[#{index + 1}]: #{result.successes.count} assertions passed in #{result.elapsed_time.time} milliseconds. #{SUCCESS_EMOJI.sample}")
				result.failures.each do |(message, backtrace, path)|
					writer.write "\n\n"
					writer.write GreenDots::Path.new([*path, "\e[31m#{message.call}\e[0m"]).render

					lines = Formatter.format(
						Lexer.lex(
							File.read(backtrace.first.path).gsub!(/^(\t+)/) { |match| " " * (match.length * 2) }
						)
					).each_line.with_index(1).to_a

					writer.write lines[(backtrace.first.lineno - 5)..(backtrace.first.lineno + 3)].map { |line, index| "#{index}:  #{line}" }.join
				end
			end
		end
	end

	def puts_results
		puts
		puts
		puts "Collated results: \n#{@results.join("\n")}"
	end
end
