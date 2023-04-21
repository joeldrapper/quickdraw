# frozen_string_literal: true

module FooMatcher
	def foo?
		assert(value == "foo") { %(Expected #{value} to be "foo" but it wasn't.) }
	end
end

include_matcher Matchers::PassFail

test "custom matcher success case" do
	expect {
		include_matcher FooMatcher

		test { expect("foo").foo? }
	}.to_pass
end

test("custom matcher fail case") do
	expect {
		include_matcher FooMatcher

		test { expect("bar").foo? }
	}.to_fail message: %(Expected bar to be "foo" but it wasn't.)
end
