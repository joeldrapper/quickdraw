# frozen_string_literal: true

require "etc"

class GreenDots::Cluster
	def self.call(n = Etc.nprocessors, &)
		spawn(n, &).wait
	end

	def self.spawn(n = Etc.nprocessors, &block)
	  new.tap do |cluster|
			n.times { cluster.fork(&block) }
		end
	end

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
