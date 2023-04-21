# frozen_string_literal: true

module FooMatcher
	def foo?
		assert(value == "foo") { %(Expected #{value} to be "foo" but it wasn't.) }
	end
end

include_matcher FooMatcher

test "custom matcher success case" do
	expect("foo").foo?
end

test("custom matcher fail case", skip: true) do
	expect("baz").foo?
end
