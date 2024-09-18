# frozen_string_literal: true

class Quickdraw::Cluster
	def self.call(n = Quickdraw::Platform.cpu_cores, &)
		spawn(n, &).wait
	end

	def self.spawn(n = Quickdraw::Platform.cpu_cores, &block)
		new.tap do |cluster|
			n.times { cluster.fork(&block) }
		end
	end

	def initialize
		@workers = []
	end

	def fork(&)
		@workers << Quickdraw::Worker.fork(&)
	end

	def terminate
		@workers.map(&:terminate)
	end

	def wait
		@workers.map(&:wait)
	end
end
