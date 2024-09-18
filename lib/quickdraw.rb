# frozen_string_literal: true

module Quickdraw
	autoload :ArgumentError, "quickdraw/errors/argument_error"
	autoload :CLI, "quickdraw/cli"
	autoload :Cluster, "quickdraw/cluster"
	autoload :ConcurrentArray, "quickdraw/concurrent_array"
	autoload :Configuration, "quickdraw/configuration"
	autoload :Context, "quickdraw/context"
	autoload :Expectation, "quickdraw/expectation"
	autoload :Map, "quickdraw/map"
	autoload :Matchers, "quickdraw/matchers"
	autoload :Minitest, "quickdraw/minitest"
	autoload :Never, "quickdraw/never"
	autoload :Pipe, "quickdraw/pipe"
	autoload :Platform, "quickdraw/platform"
	autoload :Queue, "quickdraw/queue"
	autoload :Registry, "quickdraw/registry"
	autoload :RSpec, "quickdraw/rspec"
	autoload :Run, "quickdraw/run"
	autoload :Runner, "quickdraw/runner"
	autoload :Timer, "quickdraw/timer"
	autoload :Watcher, "quickdraw/watcher"
	autoload :Worker, "quickdraw/worker"

	Null = Object.new.freeze
	Error = Module.new
	Config = Configuration.new

	def self.configure(&)
		yield Config
		Config.freeze
	end
end
