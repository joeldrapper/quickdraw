# frozen_string_literal: true

class GreenDots::Cluster
	def initialize
		@workers = []
	end

	def fork(&)
		@workers << GreenDots::Worker.fork(&)
	end

	def wait
		@workers.map(&:wait)
	end
end
