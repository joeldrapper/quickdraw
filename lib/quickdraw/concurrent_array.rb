# frozen_string_literal: true

class Quickdraw::ConcurrentArray
	def initialize
		@mutex = Mutex.new
		@array = []
	end

	def <<(element)
		@mutex.synchronize { @array << element }
	end

	def to_a
		@array.dup
	end

	def size
		@array.size
	end
end
