# frozen_string_literal: true

module Quickdraw::MinitestAdapter
	def self.extended(base)
		base.extend(ClassMethods)
		base.include(InstanceMethods)
		super
	end

	def self.included(...)
		extended(...)
		super
	end

	module ClassMethods
		def method_added(name)
			name = name.to_s

			if name.start_with?("test_")
				test(name[5..]) { public_send(name) }
			end
		end
	end

	module InstanceMethods
		def assert_equal(expected, actual, message = nil)
			assert(actual == expected) do
				message || "expcted #{actual.inspect} to equal #{expected.inspect}"
			end
		end

		def refute_equal(expected, actual, message = nil)
			refute(actual == expected) do
				message || "expcted #{actual.inspect} to not equal #{expected.inspect}"
			end
		end
	end
end
