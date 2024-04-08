# frozen_string_literal: true

require "etc"

class Quickdraw::Configuration
	DEFAULT_THREADS = 8
	DEFAULT_PROCESSES = Etc.nprocessors

	def initialize
		@registry = Quickdraw::Registry.new
		@failure_symbol = "🔴"
		@success_symbol = "🟢"
		@processes = DEFAULT_PROCESSES
		@threads = DEFAULT_THREADS
		@success_emoji = %w[💃 🕺 🎉 🎊 💪 👏 🙌 ✨ 🥳 🎈 🌈 🎯 🏆]
	end

	attr_reader :registry

	attr_accessor :failure_symbol
	attr_accessor :processes
	attr_accessor :success_emoji
	attr_accessor :success_symbol
	attr_accessor :threads

	def matcher(matcher, *types)
		@registry.register(matcher, *types)
	end
end
