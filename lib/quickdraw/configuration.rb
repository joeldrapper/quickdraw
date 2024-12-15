# frozen_string_literal: true

class Quickdraw::Configuration
	DEFAULT_PROCESSES = Quickdraw::Platform.supports_forking? ? Quickdraw::Platform.non_blocking_cores : 1
	DEFAULT_THREADS = 4

	def initialize
		@failure_symbol = "\e[31m⨯\e[0m"
		@success_symbol = "\e[32m∘\e[0m"
		@processes = DEFAULT_PROCESSES
		@threads = DEFAULT_THREADS
		@success_emoji = %w[💃 🕺 🎉 🎊 💪 👏 🙌 ✨ 🥳 🎈 🌈 🎯 🏆]
	end

	attr_accessor :failure_symbol
	attr_accessor :processes
	attr_accessor :success_emoji
	attr_accessor :success_symbol
	attr_accessor :threads
end
