# frozen_string_literal: true

module GreenDots::Matchers::ToRaise
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

	def not_to_raise
		block.call
		success!
	rescue ::Exception => e
		failure! { "Expected the block not to raise, but it raised `#{e.class}`." }
	end
end
