# frozen_string_literal: true

module Quickdraw::Assertions
	def assert_equal(a, b)
		assert(a == b) do
			"expected #{a} to == #{b}"
		end
	end

	def refute_equal(a, b)
		refute(a == b) do
			"expected #{a} to not == #{b}"
		end
	end

	def assert_empty(collection)
		assert(collection.empty?) do
			"expected #{collection.class} to be empty"
		end
	end

	def refute_empty(collection)
		refute(collection.empty?) do
			"expected #{collection.class} to not be empty"
		end
	end

	def assert_raises(error)
		yield
		failure! { "expected block to raise #{error.inspect} but nothing was raised" }
	rescue Exception => e
		assert(error === e) do
			"expected block to raise #{error.inspect} but #{e.class.inspect} was raised instead"
		end

		e
	end

	def refute_raises
		yield
		success!
	rescue Exception => e
		failure! { "expected block not to raise, but #{e.class.inspect} was raised" }
	end

	def assert_nil(value)
		assert(nil === value) do
			"expected #{value.class} to be nil"
		end
	end

	def assert_respond_to(object, method_name)
		assert(object.respond_to?(method_name)) do
			"expected #{object.inspect} to respond to ##{method_name}"
		end
	end
end
