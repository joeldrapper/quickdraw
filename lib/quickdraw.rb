# frozen_string_literal: true

module Quickdraw
	autoload :Cluster, "quickdraw/cluster"
	autoload :Configuration, "quickdraw/configuration"
	autoload :Context, "quickdraw/context"
	autoload :Expectation, "quickdraw/expectation"
	autoload :Matchers, "quickdraw/matchers"
	autoload :Pipe, "quickdraw/pipe"
	autoload :Registry, "quickdraw/registry"
	autoload :Run, "quickdraw/run"
	autoload :Runner, "quickdraw/runner"
	autoload :Timer, "quickdraw/timer"
	autoload :Worker, "quickdraw/worker"
	autoload :Queue, "quickdraw/queue"
	autoload :Map, "quickdraw/map"

	SUCCESS_EMOJI = %w[💃 🕺 🎉 🎊 💪 👏 🙌 ✨ 🥳 🎈 🌈 🎯 🏆]

	Null = Object.new.freeze
	CONFIG = Configuration.new

	module Error; end

	class TestFailure < RuntimeError
		include Error
	end

	class ArgumentError < ::ArgumentError
		include Error
	end

	def self.configure(&block)
		if block.arity == 0
			CONFIG.instance_eval(&block)
		else
			yield CONFIG
		end

		CONFIG.freeze
	end
end
