# frozen_string_literal: true

module Matchers
	module PassFail
		def to_pass
			begin
				Class.new(GreenDots::Test, &block).run
			rescue GreenDots::TestFailure => e
				failure!
			end

			success!
		end

		def to_fail(message: nil)
			begin
				Class.new(GreenDots::Test, &block).run
			rescue GreenDots::TestFailure => e
				success!
				assert(e.message == message) if message
				return
			end

			failure!
		end
	end
end
