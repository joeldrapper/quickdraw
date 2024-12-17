# frozen_string_literal: true

class Quickdraw::ConcurrentInteger
	def initialize(value = 0)
		@value = value
		@monitor = Monitor.new
	end

	def increment(n = 1)
		@monitor.synchronize { @value += n }
	end

	def value
		@monitor.synchronize { @value }
	end
end
