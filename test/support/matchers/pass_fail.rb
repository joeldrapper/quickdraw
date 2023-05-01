# frozen_string_literal: true

module Matchers
	module PassFail
		def to_pass
			begin
				Class.new(GreenDots::Test, &block).run
			rescue GreenDots::TestFailure
				failure!("")
			end

			success!
		end

		def to_fail(message: nil)
			begin
				Class.new(GreenDots::Test, &block).run
			rescue GreenDots::TestFailure => e
				success!
				if message
					if message == e.message
						success!
					else
						failure! { "Expected `#{e.message.inspect}` to equal `#{message.inspect}`." }
					end
				end

				return
			end

			failure!("")
		end
	end
end
