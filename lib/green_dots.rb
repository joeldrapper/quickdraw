# frozen_string_literal: true

module GreenDots
	autoload :Cluster, "green_dots/cluster"
	autoload :Configuration, "green_dots/configuration"
	autoload :Context, "green_dots/context"
	autoload :Expectation, "green_dots/expectation"
	autoload :Matchers, "green_dots/matchers"
	autoload :Registry, "green_dots/registry"
	autoload :Runner, "green_dots/runner"
	autoload :Run, "green_dots/run"
	autoload :Timer, "green_dots/timer"
	autoload :Worker, "green_dots/worker"
	autoload :Pipe, "green_dots/pipe"

	SUCCESS_EMOJI = %w[💃 🕺 🎉 🎊 💪 👏 🙌 ✨ 🥳 🎈 🌈 🎯 🏆]

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

	def self.run(...)
		Run.new(...).call
	end
end
