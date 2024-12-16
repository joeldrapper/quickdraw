# frozen_string_literal: true

module Quickdraw
	autoload :ArgumentError, "quickdraw/errors/argument_error"
	autoload :CLI, "quickdraw/cli"
	autoload :Cluster, "quickdraw/cluster"
	autoload :Configuration, "quickdraw/configuration"
	autoload :Platform, "quickdraw/platform"
	autoload :Queue, "quickdraw/queue"
	autoload :Runner, "quickdraw/runner"
	autoload :Test, "quickdraw/test"
	autoload :Timer, "quickdraw/timer"
	autoload :Worker, "quickdraw/worker"
	autoload :ConcurrentInteger, "quickdraw/concurrent_integer"
	autoload :ConcurrentArray, "quickdraw/concurrent_array"

	Null = Object.new.freeze
	Error = Module.new
	Config = Configuration.new

	def self.configure(&)
		yield Config
		Config.freeze
	end
end
