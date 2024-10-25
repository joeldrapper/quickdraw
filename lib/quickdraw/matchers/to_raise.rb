# frozen_string_literal: true

module Quickdraw::Matchers::ToRaise
	def to_raise(error = ::Exception)
		expectation_block = @block

		begin
			expectation_block.call
		rescue error => e
			success!(depth: 1)
			yield(e) if block_given?
			return
		rescue ::Exception => e
			return failure!(depth: 1) { "expected `#{error.inspect}` to be raised but `#{e.class.inspect}` was raised" }
		end

		failure!(depth: 1) { "expected #{error} to be raised but wasn't" }
	end

	def not_to_raise
		@block.call
		success!(depth: 1)
	rescue ::Exception => e
		failure!(depth: 1) { "expected the block not to raise, but it raised `#{e.class}`" }
	end
end
