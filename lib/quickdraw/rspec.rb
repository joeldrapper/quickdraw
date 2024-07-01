# frozen_string_literal: true

require "rspec/expectations"

module Quickdraw::RSpec
	def self.extended(base)
		base.use(To)
		base.include(Matchers)

		# Add support for `RSpec.describe`
		base.const_set(:RSpec, Class.new do
			define_singleton_method(:describe) do |*args, &block|
				Class.new(base, &block)
			end
		end)
	end

	def describe(description, &)
		Class.new(self, &)
	end

	def context(...) = describe(...)
	def it(...) = test(...)

	def let(name, &block)
		instance_variable = :"@#{name}"

		define_method(name) do
			if instance_variable_defined?(instance_variable)
				instance_variable_get(instance_variable)
			else
				instance_variable_set(instance_variable, instance_exec(&block))
			end
		end
	end

	module To
		def to(matcher)
			sub = (Quickdraw::Never === @block) ? @subject : @block

			assert(matcher.matches?(sub)) do
				if matcher.respond_to?(:failure_message)
					matcher.failure_message
				else
					"Failure"
				end
			end
		end

		def not_to(matcher)
			sub = (Quickdraw::Never === @block) ? @subject : @block

			refute(matcher.matches?(sub)) do
				if matcher.respond_to?(:failure_message_when_negated)
					matcher.failure_message_when_negated
				else
					"Failure"
				end
			end
		end
	end

	module Matchers
		define_method :all, ::RSpec::Matchers.instance_method(:all)
		define_method :be, ::RSpec::Matchers.instance_method(:be)
		define_method :be_a, ::RSpec::Matchers.instance_method(:be_a)
		define_method :be_a_kind_of, ::RSpec::Matchers.instance_method(:be_a_kind_of)
		define_method :be_an_instance_of, ::RSpec::Matchers.instance_method(:be_an_instance_of)
		define_method :be_between, ::RSpec::Matchers.instance_method(:be_between)
		define_method :be_falsey, ::RSpec::Matchers.instance_method(:be_falsey)
		define_method :be_nil, ::RSpec::Matchers.instance_method(:be_nil)
		define_method :be_truthy, ::RSpec::Matchers.instance_method(:be_truthy)
		define_method :be_within, ::RSpec::Matchers.instance_method(:be_within)
		define_method :change, ::RSpec::Matchers.instance_method(:change)
		define_method :contain_exactly, ::RSpec::Matchers.instance_method(:contain_exactly)
		define_method :cover, ::RSpec::Matchers.instance_method(:cover)
		define_method :end_with, ::RSpec::Matchers.instance_method(:end_with)
		define_method :eq, ::RSpec::Matchers.instance_method(:eq)
		define_method :eql, ::RSpec::Matchers.instance_method(:eql)
		define_method :equal, ::RSpec::Matchers.instance_method(:equal)
		define_method :exist, ::RSpec::Matchers.instance_method(:exist)
		define_method :have_attributes, ::RSpec::Matchers.instance_method(:have_attributes)
		define_method :include, ::RSpec::Matchers.instance_method(:include)
		define_method :match, ::RSpec::Matchers.instance_method(:match)
		define_method :match_array, ::RSpec::Matchers.instance_method(:match_array)
		define_method :output, ::RSpec::Matchers.instance_method(:output)
		define_method :raise_error, ::RSpec::Matchers.instance_method(:raise_error)
		define_method :respond_to, ::RSpec::Matchers.instance_method(:respond_to)
		define_method :satisfy, ::RSpec::Matchers.instance_method(:satisfy)
		define_method :start_with, ::RSpec::Matchers.instance_method(:start_with)
		define_method :throw_symbol, ::RSpec::Matchers.instance_method(:throw_symbol)
		define_method :yield_control, ::RSpec::Matchers.instance_method(:yield_control)
		define_method :yield_successive_args, ::RSpec::Matchers.instance_method(:yield_successive_args)
		define_method :yield_with_args, ::RSpec::Matchers.instance_method(:yield_with_args)
		define_method :yield_with_no_args, ::RSpec::Matchers.instance_method(:yield_with_no_args)
	end
end
