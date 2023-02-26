# frozen_string_literal: true

module GreenDots::Matchers
	module ToRaise
		def to_raise(error = ::Exception)
			@result = "Expected #{error} to be raised but wasn't."
			expectation_block = block

			begin
				expectation_block.call
			rescue error => e
				success!
				yield(e) if block_given?
			rescue ::Exception => e
				@result = "Expected `#{error.inspect}` to be raised but `#{e.class.inspect}` was raised."
			end
		end
	end
end
