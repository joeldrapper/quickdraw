# frozen_string_literal: true

class Quickdraw::Worker
	def self.fork(&block)
		pipe = Quickdraw::Pipe.new

		pid = Process.fork do
			pipe.with_writer(&block)
		end

		new(pid:, pipe:)
	end

	def initialize(pid:, pipe:)
		@pid = pid
		@pipe = pipe
	end

	def wait
		Process.wait(@pid)
		@pipe.with_reader(&:read)
	end

	def terminate
		Process.kill("TERM", @pid)
	end
end
