# frozen_string_literal: true

module GreenDots::Matchers
	module ToRaise
		def to_raise(error = ::Exception)
			expectation_block = block

			begin
				expectation_block.call
			rescue error => e
				success!
				yield(e) if block_given?
				return
			rescue ::Exception => e
				return failure! { "Expected `#{error.inspect}` to be raised but `#{e.class.inspect}` was raised." }
			end

			failure! { "Expected #{error} to be raised but wasn't." }
		end

		def to_not_raise
			block.call
			success!
		rescue ::Exception => e
			@result = "Expected the block not to raise, but it raised `#{e.class}(#{e}`."
		end
	end
end
