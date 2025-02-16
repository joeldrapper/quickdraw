# frozen_string_literal: true

class Quickdraw::ConcurrentArray
	def initialize
		@array = []
		@monitor = Monitor.new
	end

	def <<(value)
		@monitor.synchronize { @array << value }
	end

	def each(&block)
		@monitor.synchronize { @array.each(&block) }
	end

	def concat(other)
		@monitor.synchronize { @array.concat(other) }
	end

	def size
		@monitor.synchronize { @array.size }
	end

	def any?
		@monitor.synchronize { @array.any? }
	end

	def to_a
		@monitor.synchronize { @array.dup }
	end
end
