# frozen_string_literal: true

module Quickdraw::Assertions
	def assert_equal(expected, actual)
		assert(expected == actual) do
			"expected #{expected.inspect} to == #{actual.inspect}"
		end
	end

	def refute_equal(expected, actual)
		refute(expected == actual) do
			"expected #{expected.inspect} to not == #{actual.inspect}"
		end
	end

	def assert_raises(expected)
		yield
		failure! { "expected block to raise #{expected.inspect} but nothing was raised" }
	rescue Exception => error
		assert(expected === error) do
			"expected block to raise #{expected.inspect} but #{error.class.inspect} was raised instead"
		end

		error
	end

	def refute_raises
		yield
		success!
	rescue Exception => error
		failure! { "expected block not to raise, but #{error.class.inspect} was raised" }
	end

	def assert_operator(object, operator, other)
		assert object.public_send(operator, other) do
			"expected #{object.inspect} to #{operator} #{other.inspect}"
		end
	end

	def assert_same(expected, actual)
		assert expected.equal?(actual) do
			"expected #{expected.inspect} to be the same object as #{actual.inspect}"
		end
	end

	def refute_same(expected, actual)
		refute expected.equal?(actual) do
			"expected #{expected.inspect} not to be the same object as #{actual.inspect}"
		end
	end
end
