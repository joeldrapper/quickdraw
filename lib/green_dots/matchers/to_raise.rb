# frozen_string_literal: true

module GreenDots::Matchers
	module ToRaise
		def to_raise(error = ::Exception)
			@result = "Expected #{error} to be raised but wasn't."
			expectation_block = block
			
			begin
				expectation_block.call
			rescue ::Exception => e
				if e.is_a? error
					success!
					yield(e) if block_given?
				else
					@result = "Expected an #{error} but got a #{e.class}(#{e})"
				end
			end
		end
	end
end
