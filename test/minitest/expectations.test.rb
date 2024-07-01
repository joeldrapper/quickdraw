# frozen_string_literal: true

use Quickdraw::Minitest::Expectations

test "must_be" do
	expect("").must_be(:empty?)
	expect(2).must_be(:<=, 2)
end
