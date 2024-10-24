# frozen_string_literal: true

require "socket"

class Quickdraw::Worker
	def self.fork
		parent_socket, child_socket = UNIXSocket.pair

		pid = Process.fork do
			parent_socket.close
			yield(child_socket)
		end

		child_socket.close
		new(pid:, socket: parent_socket)
	end

	def initialize(pid:, socket:)
		@pid = pid
		@socket = socket
	end

	attr_reader :pid, :socket

	def wait
		Process.wait(@pid)
	end

	def terminate
		Process.kill("TERM", @pid)
	end
end
