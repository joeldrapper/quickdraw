# frozen_string_literal: true

module Quickdraw
	autoload :ArgumentError, "quickdraw/errors/argument_error"
	autoload :Cluster, "quickdraw/cluster"
	autoload :Configuration, "quickdraw/configuration"
	autoload :Context, "quickdraw/context"
	autoload :Expectation, "quickdraw/expectation"
	autoload :Map, "quickdraw/map"
	autoload :Matchers, "quickdraw/matchers"
	autoload :Pipe, "quickdraw/pipe"
	autoload :Queue, "quickdraw/queue"
	autoload :Registry, "quickdraw/registry"
	autoload :Run, "quickdraw/run"
	autoload :Timer, "quickdraw/timer"
	autoload :Worker, "quickdraw/worker"
	autoload :ConcurrentArray, "quickdraw/concurrent_array"
	autoload :RSpec, "quickdraw/rspec"
	autoload :Minitest, "quickdraw/minitest"

	Null = Object.new.freeze
	Error = Module.new
	Config = Configuration.new

	def self.configure(&)
		yield Config
		Config.freeze
	end
end
