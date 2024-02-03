# frozen_string_literal: true

module GreenDots
	autoload :Cluster, "green_dots/cluster"
	autoload :Configuration, "green_dots/configuration"
	autoload :Context, "green_dots/context"
	autoload :Expectation, "green_dots/expectation"
	autoload :Matchers, "green_dots/matchers"
	autoload :Registry, "green_dots/registry"
	autoload :Result, "green_dots/result"
	autoload :Run, "green_dots/run"
	autoload :TimeElapsed, "green_dots/time_elapsed"
	autoload :Worker, "green_dots/worker"

	Null = Object.new.freeze
	Config = Configuration.new



	module Error; end

	class TestFailure < RuntimeError
		include Error
	end

	class ArgumentError < ::ArgumentError
		include Error
	end

	def self.configure(&block)
		if block.arity == 0
			Config.instance_eval(&block)
		else
			yield Config
		end
	end

	def self.timer(&block)
		start = Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
		yield
		finish = Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
		GreenDots::TimeElapsed.new(start, finish)
	end

	def self.run(...)
		Run.new(...).call
	end
end
