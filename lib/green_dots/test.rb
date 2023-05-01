# frozen_string_literal: true

class GreenDots::Test
	DEFAULT_MATCHERS = [
		GreenDots::Matchers::ToBe,
		GreenDots::Matchers::ToBeA,
		GreenDots::Matchers::ToRaise,
		GreenDots::Matchers::Equality,
		GreenDots::Matchers::ToReceive,
		GreenDots::Matchers::TruthyFalsy
	].freeze

	extend GreenDots::Context

	class << self
		def run(run = GreenDots::Run.new)
			@sub_contexts&.each { |c| c.run(run) }

			return unless @tests

			new(run).run(@tests)
		end

		def use(*args)
			args.each { |m| matchers << m }
		end

		def matchers
			@matchers ||= if superclass < GreenDots::Test
				superclass.matchers.dup
			else
				Concurrent::Set.new(DEFAULT_MATCHERS)
			end
		end
	end

	def initialize(run)
		@run = run
		@expectations = []
		@matchers = self.class.matchers
	end

	def run(tests)
		tests.shuffle.each do |test|
			@name = test[:name]
			@skip = test[:skip]

			instance_eval(&test[:block])

			resolve
		end
	ensure
		@name = nil
		@skip = nil
	end

	def expect(value = GreenDots::Null, &block)
		type = GreenDots::Null == value ? block : value

		expectation_class = GreenDots::CONFIGURATION.registry.expectation_for(type, matchers: @matchers)

		# location = caller_locations(1, 1).first

		expectation = expectation_class.new(self, value, &block)

		@expectations << expectation
		expectation
	end

	def resolve
		@expectations.each(&:resolve)
	ensure
		@expectations.clear
	end

	def assert(value, &block)
		block ||= -> { "Expected #{value.inspect} to be truthy." }
		value ? success! : failure!(block.call)
	end

	def refute(value, &block)
		block ||= -> { "Expected #{value.inspect} to be falsy." }
		value ? failure!(block.call) : success!
	end

	def success!
		if @skip
			@run.failure! %(The skipped test "#{@name}" started passing.)
		else
			@run.success!
		end
	end

	def failure!(message)
		if @skip
			@run.success!
		else
			@run.failure!(message)
		end
	end
end
