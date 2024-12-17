# frozen_string_literal: true

require "minitest/assertions"

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

			return unless name.start_with?("test_")

			location = instance_method(name).source_location

			class_eval(<<~RUBY, *location)
			  test("#{name[5..].tr('_', ' ')}") do
					#{name}
				end
			RUBY
		end
	end

	module InstanceMethods
		def assert(value, message = nil)
			case message
			when nil
				super(value) { yield }
			when Proc
				super(value, &message)
			else
				super(value) { message }
			end
		end

		def refute(value, message = nil)
			super(value) { message || yield }
		end

		define_method :assert_empty, Minitest::Assertions.instance_method(:assert_empty)
		define_method :assert_equal, Minitest::Assertions.instance_method(:assert_equal)
		define_method :assert_in_delta, Minitest::Assertions.instance_method(:assert_in_delta)
		define_method :assert_in_epsilon, Minitest::Assertions.instance_method(:assert_in_epsilon)
		define_method :assert_includes, Minitest::Assertions.instance_method(:assert_includes)
		define_method :assert_instance_of, Minitest::Assertions.instance_method(:assert_instance_of)
		define_method :assert_kind_of, Minitest::Assertions.instance_method(:assert_kind_of)
		define_method :assert_match, Minitest::Assertions.instance_method(:assert_match)
		define_method :assert_nil, Minitest::Assertions.instance_method(:assert_nil)
		define_method :assert_operator, Minitest::Assertions.instance_method(:assert_operator)
		define_method :assert_path_exists, Minitest::Assertions.instance_method(:assert_path_exists)
		define_method :assert_pattern, Minitest::Assertions.instance_method(:assert_pattern)
		define_method :assert_predicate, Minitest::Assertions.instance_method(:assert_predicate)
		define_method :assert_raises, Minitest::Assertions.instance_method(:assert_raises)
		define_method :assert_respond_to, Minitest::Assertions.instance_method(:assert_respond_to)
		define_method :assert_same, Minitest::Assertions.instance_method(:assert_same)
		define_method :assert_throws, Minitest::Assertions.instance_method(:assert_throws)

		define_method :refute_empty, Minitest::Assertions.instance_method(:refute_empty)
		define_method :refute_equal, Minitest::Assertions.instance_method(:refute_equal)
		define_method :refute_in_delta, Minitest::Assertions.instance_method(:refute_in_delta)
		define_method :refute_in_epsilon, Minitest::Assertions.instance_method(:refute_in_epsilon)
		define_method :refute_includes, Minitest::Assertions.instance_method(:refute_includes)
		define_method :refute_instance_of, Minitest::Assertions.instance_method(:refute_instance_of)
		define_method :refute_kind_of, Minitest::Assertions.instance_method(:refute_kind_of)
		define_method :refute_match, Minitest::Assertions.instance_method(:refute_match)
		define_method :refute_nil, Minitest::Assertions.instance_method(:refute_nil)
		define_method :refute_operator, Minitest::Assertions.instance_method(:refute_operator)
		define_method :refute_path_exists, Minitest::Assertions.instance_method(:refute_path_exists)
		define_method :refute_pattern, Minitest::Assertions.instance_method(:refute_pattern)
		define_method :refute_predicate, Minitest::Assertions.instance_method(:refute_predicate)
		define_method :refute_respond_to, Minitest::Assertions.instance_method(:refute_respond_to)
		define_method :refute_same, Minitest::Assertions.instance_method(:refute_same)

		private define_method :message, Minitest::Assertions.instance_method(:message)
		private define_method :diff, Minitest::Assertions.instance_method(:diff)
		private define_method :things_to_diff, Minitest::Assertions.instance_method(:things_to_diff)
		private define_method :mu_pp_for_diff, Minitest::Assertions.instance_method(:mu_pp_for_diff)
		private define_method :mu_pp, Minitest::Assertions.instance_method(:mu_pp)

		def flunk(message)
			failure! { message }
		end

		def pass
			success!
		end
	end
end
