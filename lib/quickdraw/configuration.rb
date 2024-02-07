# frozen_string_literal: true

require "etc"

class Quickdraw::Configuration
	def initialize
		@registry = Quickdraw::Registry.new
		@failure_symbol = "🔴"
		@success_symbol = "🟢"
		@number_of_processes = Etc.nprocessors
		@number_of_threads_per_process = 2
		@glob = "./**/*.test.rb"
	end

	attr_reader :registry
	attr_accessor :failure_symbol
	attr_accessor :success_symbol
	attr_accessor :number_of_processes
	attr_accessor :number_of_threads_per_process
	attr_accessor :glob

	def matcher(matcher, *types)
		@registry.register(matcher, *types)
	end
end
