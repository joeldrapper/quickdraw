# frozen_string_literal: true

module Quickdraw::Assertions
	def assert_equal(actual, expected)
		assert(actual == expected) do
			<<~MESSAGE
				\e[34mExpected:\e[0m

				#{actual.inspect}

				\e[34mto be == to\e[0m

				#{expected.inspect}
			MESSAGE
		end
	end

	def refute_equal(actual, expected)
		refute(actual == expected) do
			"expected #{actual.inspect} not to == #{expected.inspect}"
		end
	end

	def assert_includes(collection, member)
		assert(collection.include?(member)) do
			"expected #{collection.inspect} to include #{member.inspect}"
		end
	end

	def refute_includes(collection, member)
		refute(collection.include?(member)) do
			"expected #{collection.inspect} not to include #{member.inspect}"
		end
	end

	def assert_operator(object, operator, other)
		assert object.public_send(operator, other) do
			"expected #{object.inspect} to #{operator} #{other.inspect}"
		end
	end

	def refute_operator(object, operator, other)
		refute object.public_send(operator, other) do
			"expected #{object.inspect} not to #{operator} #{other.inspect}"
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

	def assert_same(actual, expected)
		assert actual.equal?(expected) do
			"expected #{actual.inspect} to be the same object as #{expected.inspect}"
		end
	end

	def refute_same(actual, expected)
		refute actual.equal?(expected) do
			"expected #{actual.inspect} not to be the same object as #{expected.inspect}"
		end
	end
end
