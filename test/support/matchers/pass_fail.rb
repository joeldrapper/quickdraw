# frozen_string_literal: true

module Matchers
	module PassFail
		def to_pass
			begin
				Class.new(GreenDots::Test, &block).run
			rescue GreenDots::TestFailure => e
				error!
			end

			success!
		end

		def to_fail(message: nil)
			begin
				Class.new(GreenDots::Test, &block).run
			rescue GreenDots::TestFailure => e
				assert(e.message == message) if message
				return success!
			end

			error!
		end
	end
end
