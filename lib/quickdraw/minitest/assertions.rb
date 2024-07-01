# frozen_string_literal: true

module Quickdraw::Minitest::Assertions
	def assert(a, b = Quickdraw::Null)
		if Quickdraw::Null == b
			super(a)
		else
			super(a) { b }
		end
	end

	def refute(a, b = Quickdraw::Null)
		if Quickdraw::Null == b
			super(a)
		else
			super(a) { b }
		end
	end

	def assert_equal(expected, actual)
		assert(expected == actual) do
			"expected #{expected.inspect} to be equal to #{actual.inspect}"
		end
	end

	def refute_equal(expected, actual)
		assert(expected != actual) do
			"expected #{expected.inspect} to not be equal to #{actual.inspect}"
		end
	end

	def assert_empty(object)
		assert(object.empty?) do
			"expected #{object.inspect} to be empty"
		end
	end

	def refute_empty(object)
		refute(object.empty?) do
			"expected #{object.inspect} to not be empty"
		end
	end

	def assert_predicate(object, method)
		assert(object.public_send(method)) do
			"expected #{object.inspect} to be #{method}"
		end
	end

	def refute_predicate(object, method)
		refute(object.public_send(method)) do
			"expected #{object.inspect} to not be #{method}"
		end
	end

	def assert_respond_to(object, method)
		assert(object.respond_to?(method)) do
			"expected #{object.inspect} to respond to #{method}"
		end
	end

	def refute_respond_to(object, method)
		refute(object.respond_to?(method)) do
			"expected #{object.inspect} to not respond to #{method}"
		end
	end

	def assert_same(expected, actual)
		assert(expected.equal?(actual)) do
			"expected #{expected.inspect} to be the same as #{actual.inspect}"
		end
	end

	def refute_same(expected, actual)
		refute(expected.equal?(actual)) do
			"expected #{expected.inspect} to not be the same as #{actual.inspect}"
		end
	end
end
