# frozen_string_literal: true

require "etc"

class Quickdraw::Configuration
	DEFAULT_CPU_CORE_RATIO = 1.4
	DEFAULT_THREAD_COUNT = 8

	def initialize
		@registry = Quickdraw::Registry.new
		@failure_symbol = "🔴"
		@success_symbol = "🟢"
		@processes = (Etc.nprocessors * DEFAULT_CPU_CORE_RATIO).floor
		@threads = 8
		@glob = "./**/*.test.rb"
		@success_emoji = %w[💃 🕺 🎉 🎊 💪 👏 🙌 ✨ 🥳 🎈 🌈 🎯 🏆]
	end

	attr_reader :registry

	attr_accessor :failure_symbol
	attr_accessor :success_symbol
	attr_accessor :processes
	attr_accessor :threads
	attr_accessor :glob
	attr_accessor :success_emoji

	def matcher(matcher, *types)
		@registry.register(matcher, *types)
	end
end
