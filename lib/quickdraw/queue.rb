# frozen_string_literal: true

class Quickdraw::Queue
	def initialize
		@array = []
		@mutex = Mutex.new
	end

	def <<(item)
		@mutex.synchronize { @array << item }
	end

	def drain
		loop do
			if (value = shift)
				yield(value)
			else
				break
			end
		end
	end

	def pop
		@mutex.synchronize { @array.pop }
	end

	def shift
		@mutex.synchronize { @array.shift }
	end

	def empty?
		@array.empty?
	end

	def size
		@array.size
	end
end
