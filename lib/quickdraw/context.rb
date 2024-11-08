# frozen_string_literal: true

require "set"

class Quickdraw::Context
	class << self
		def test(name = nil, skip: false, &block)
			run << [name, skip, block, self]
		end

		def use(*new_matchers)
			matchers = self.matchers

			i = 0
			number_of_new_matchers = new_matchers.size

			while i < number_of_new_matchers
				matchers << new_matchers[i]
				i += 1
			end
		end

		def matchers
			Quickdraw::MATCHERS.fetch_or_store(self) do
				if superclass < Quickdraw::Context
					superclass.matchers.dup
				else
					Concurrent::Set.new
				end
			end
		end

		def run_test(name, skip, runner, &)
			instance = new(name, skip, runner, matchers)
			instance.instance_exec(&)
			instance.resolve
		rescue Exception => error
			runner.error!(name, error)
		end
	end

	def initialize(name, skip, runner, matchers)
		@name = name
		@skip = skip
		@runner = runner
		@matchers = matchers

		@expectations = Concurrent::Array.new
	end

	def expect(value = Quickdraw::Null, &block)
		type = (Quickdraw::Null == value) ? block : value
		expectation = expectation_for(type).new(self, value, &block)
		@expectations << expectation
		expectation
	end

	private def expectation_for(type)
		Quickdraw::Config.registry.expectation_for(
			type,
			matchers: @matchers,
		)
	end

	def resolve
		i = 0
		expectations_size = @expectations.size

		while i < expectations_size
			@expectations[i].resolve
			i += 1
		end
	ensure
		@expectations.clear
	end

	def assert(value)
		if value
			success!(depth: 1)
		elsif block_given?
			failure!(depth: 1) { yield(value) }
		else
			failure!(depth: 1) { "expected #{value.inspect} to be truthy" }
		end
	end

	def refute(value)
		if !value
			success!(depth: 1)
		elsif block_given?
			failure!(depth: 1) { yield(value) }
		else
			failure!(depth: 1) { "expected #{value.inspect} to be falsy" }
		end
	end

	def success!(depth:)
		if @skip
			@runner.failure!(@name, depth:) { "The skipped test `#{@name}` started passing." }
		else
			@runner.success!(@name, depth:)
		end
	end

	def failure!(depth:, &)
		if @skip
			@runner.success!(@name, depth:)
		else
			@runner.failure!(@name, depth:, &)
		end
	end
end
