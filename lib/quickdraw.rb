# frozen_string_literal: true

module Quickdraw
	autoload :ArgumentError, "quickdraw/errors/argument_error"
	autoload :Assertions, "quickdraw/assertions"
	autoload :CLI, "quickdraw/cli"
	autoload :Cluster, "quickdraw/cluster"
	autoload :ConcurrentArray, "quickdraw/concurrent_array"
	autoload :ConcurrentInteger, "quickdraw/concurrent_integer"
	autoload :Configuration, "quickdraw/configuration"
	autoload :Platform, "quickdraw/platform"
	autoload :Queue, "quickdraw/queue"
	autoload :Runner, "quickdraw/runner"
	autoload :Test, "quickdraw/test"
	autoload :Timer, "quickdraw/timer"
	autoload :Worker, "quickdraw/worker"

	Null = Object.new.freeze
	Error = Module.new
	Config = Configuration.new

	def self.configure(&)
		yield Config
		Config.freeze
	end
end
