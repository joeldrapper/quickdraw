# frozen_string_literal: true

module Quickdraw::Watcher
	def self.watch(glob, latency: 0.1)
		mtimes = {}
		running = true

		puts "[Quickdraw] Watching..."

		trap("INT") do
			puts "\n[Quickdraw] Exiting..."
			running = false
		end

		while running
			modified_paths = nil

			files = Dir.glob(glob).each do |file_path|
				mtime = begin
					File.mtime(file_path)
				rescue Errno::ENOENT
					next
				end

				if mtimes[file_path] != mtime
					mtimes[file_path] = mtime
					(modified_paths ||= []) << file_path
				end
			end

			yield(modified_paths) if modified_paths

			sleep latency
		end
	end
end
