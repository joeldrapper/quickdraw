# frozen_string_literal: true

module GreenDots::Matchers
	module ToNotRaise
		def to_not_raise
			block.call
			success!
		rescue ::Exception => e
			@result = "Expected not to raise, but raised #{e.class}(#{e})"
		end
	end
end
