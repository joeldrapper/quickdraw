# frozen_string_literal: true

module FooMatcher
	def foo?
		assert(subject == "foo") { %(Expected #{subject} to be "foo" but it wasn't.) }
	end
end

use Matchers::PassFail

test "custom matcher success case" do
	expect {
		use FooMatcher

		test { expect("foo").foo? }
	}.to_pass
end

test("custom matcher fail case") do
	expect {
		use FooMatcher

		test { expect("bar").foo? }
	}.to_fail message: %(Expected bar to be "foo" but it wasn't.)
end
