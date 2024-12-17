# frozen_string_literal: true

class Quickdraw::Cluster
	def initialize
		@workers = []
	end

	def fork(&)
		Quickdraw::Worker.fork(&).tap { |it| @workers << it }
	end

	def terminate
		@workers.map(&:terminate)
	end

	def wait
		@workers.map(&:wait)
	end
end
