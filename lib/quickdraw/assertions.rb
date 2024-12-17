# frozen_string_literal: true

module Quickdraw::Assertions
	def assert_equal(expected, actual, depth: 0)
		depth += 1

		assert(expected == actual, depth:) do
			"expected #{expected.inspect} to == #{actual.inspect}"
		end
	end

	def refute_equal(expected, actual, depth: 0)
		depth += 1

		refute(expected == actual) do
			"expected #{expected.inspect} to not == #{actual.inspect}"
		end
	end

	def assert_raises(expected, depth: 0)
		depth += 1
		yield
		failure!(depth:) { "expected block to raise #{expected.inspect} but nothing was raised" }
	rescue Exception => error
		assert(expected === error, depth:) do
			"expected block to raise #{expected.inspect} but #{error.class.inspect} was raised instead"
		end

		error
	end

	def refute_raises(depth: 0)
		depth += 1
		yield
		success!
	rescue Exception => error
		failure!(depth:) { "expected block not to raise, but #{error.class.inspect} was raised" }
	end

	def assert_operator(object, operator, other, depth: 0)
		depth += 1

		assert object.public_send(operator, other), depth: do
			"expected #{object.inspect} to #{operator} #{other.inspect}"
		end
	end

	def assert_same(expected, actual, depth: 0)
		depth += 1

		assert expected.equal?(actual), depth: do
			"expected #{expected.inspect} to be the same object as #{actual.inspect}"
		end
	end

	def refute_same(expected, actual, depth: 0)
		depth += 1

		refute expected.equal?(actual), depth: do
			"expected #{expected.inspect} not to be the same object as #{actual.inspect}"
		end
	end
end
