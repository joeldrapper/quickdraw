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
			return failure! { "expected `#{error.inspect}` to be raised but `#{e.class.inspect}` was raised" }
		end

		failure! { "expected #{error} to be raised but wasn't" }
	end

	def not_to_raise
		block.call
		success!
	rescue ::Exception => e
		failure! { "expected the block not to raise, but it raised `#{e.class}`" }
	end
end
