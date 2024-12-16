# frozen_string_literal: true

require "optparse"

class Quickdraw::CLI
	CONFIG_PATH = File.expand_path("config/quickdraw.rb")

	def initialize(args)
		@args = args
	end

	def call
		parse_options
		parse_files
		run
	end

	def parse_options
		OptionParser.new do |parser|
			parser.banner = "Usage: bundle exec qt [options]"

			parser.on("-h", "--help", "Prints this help") do
				puts parser
				exit
			end

			parser.on("-p N", "--processes N", Integer, "Number of Ruby Processes to fork") do |it|
				self.processes = it
			end

			parser.on("-m", "--max", "Use all available CPU cores") do
				max!
			end

			parser.on("-e", "--efficiency", "Use efficiency cores (Apple M-series Macs only)") do
				efficiency!
			end

			parser.on("-w", "--watch", "Watch for changes") do
				self.watch = true
			end

			parser.on("-t N", "--threads N", Integer, "Number of Threads per Process") do |it|
				self.threads = it
			end

			parser.on("-s N", "--seed N", Integer, "Seed for randomization") do |it|
				self.seed = it
			end
		end.parse!(@args)
	end

	def parse_files
		@files = @args[0] || "./**/*.test.rb"
	end

	def processes=(value)
		if Process.respond_to?(:fork)
			@processes = value
		else
			fail "Forking processes is not supported on this platform."
		end
	end

	def watch=(value)
		if Quickdraw::Platform.supports_forking?
			@watch = true
		else
			fail "You cannot use the watch mode on this platform because forking processes is not supported."
		end
	end

	def threads=(value)
		@threads = value
	end

	def seed=(value)
		@seed = value
	end

	def efficiency!
		if Quickdraw::Platform.m_series?
			fail "You cannot use the efficiency flag with the processes flag." if @processes

			Quickdraw::Platform.efficiency_cores
			`taskpolicy -b -p #{Process.pid}`
		else
			fail "Efficiency cores are only available on M-series Macs."
		end
	end

	def max!
		fail "You cannot use the max flag with the processes flag." if @processes

		Quickdraw::Platform.cpu_cores
	end

	def fail(message)
		warn message
		exit(1)
	end

	def run
		@watch ? watch : run_once
	end

	def watch
		require "io/watch"

		IO::Watch::Monitor.new(["."], latency: 0.1).run do |event|
			Process.fork do
				print "\e[H\e[2J"
				run_once
			end
		end
	end

	def run_once
		require CONFIG_PATH if File.exist?(CONFIG_PATH)

		$quickdraw_runner = Quickdraw::Runner.new(
			processes: @processes || Quickdraw::Config.processes,
			threads: @threads || Quickdraw::Config.threads,
			files: Dir.glob(@files),
			seed: @seed || Random.new_seed,
		)

		$quickdraw_runner.call
	end
end
