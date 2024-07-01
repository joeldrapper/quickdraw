# frozen_string_literal: true

module Quickdraw::Minitest
	autoload :Assertions, "quickdraw/minitest/assertions"
	autoload :Expectations, "quickdraw/minitest/expectations"

	def self.extended(base)
		base.include(Quickdraw::Minitest::Assertions)
	end

	def skip(*args, **kwargs, &)
		test(*args, **kwargs, skip: true, &)
	end
end
