# frozen_string_literal: true

class GreenDots::Map
	include Enumerable

	def initialize
		@hash = {}
		@mutex = Mutex.new
	end

	def [](value)
		@hash[value]
	end

	def []=(key, value)
		@mutex.synchronize do
			@hash[key] = value
		end
	end

	def each(&)
		@hash.each(&)
	end

	def clear
		@mutex.synchronize do
			@hash.clear
		end
	end
end
