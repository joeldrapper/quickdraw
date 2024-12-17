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

	def assert_includes(collection, item)
		assert(collection.include?(item)) do
			"expected #{collection.inspect} to include #{item.inspect}"
		end
	end

	def refute_includes(collection, item)
		refute(collection.include?(item)) do
			"expected #{collection.inspect} to not include #{item.inspect}"
		end
	end

	def assert_instance_of(object, klass)
		assert(object.instance_of?(klass)) do
			"expected #{object.class} to be an instance of #{klass}"
		end
	end

	def refute_instance_of(object, klass)
		refute(object.instance_of?(klass)) do
			"expected #{object.class} to not be an instance of #{klass}"
		end
	end

	def assert_kind_of(object, klass)
		assert(object.kind_of?(klass)) do
			"expected #{object.class} to be a kind of #{klass}"
		end
	end

	def assert_match(pattern, object)
		assert(pattern =~ object) do
			"expected #{object.inspect} to match #{pattern.inspect}"
		end
	end

	def refute_match(pattern, object)
		refute(pattern =~ object) do
			"expected #{object.inspect} to not match #{pattern.inspect}"
		end
	end

	def refute_kind_of(object, klass)
		refute(object.kind_of?(klass)) do
			"expected #{object.class} to not be a kind of #{klass}"
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

	def assert_operator(object, operator, other)
		assert object.public_send(operator, other) do
			"expected #{object.inspect} to #{operator} #{other.inspect}"
		end
	end

	def refute_operator(object, operator, other)
		refute object.public_send(operator, other) do
			"expected #{object.inspect} to not #{operator} #{other.inspect}"
		end
	end

	def assert_respond_to(object, method_name)
		assert object.respond_to?(method_name) do
			"expected #{object.inspect} to respond to ##{method_name}"
		end
	end

	def assert_same(a, b)
		assert a.equal?(b) do
			"expected #{a.inspect} to be the same object as #{b.inspect}"
		end
	end

	def refute_same(a, b)
		refute a.equal?(b) do
			"expected #{a.inspect} to not be the same object as #{b.inspect}"
		end
	end
end
