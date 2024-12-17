# frozen_string_literal: true

class MinitestTest < Quickdraw::Test
	include Quickdraw::MinitestAdapter

	def test_something
		assert_equal(1, 2)
	end
end
