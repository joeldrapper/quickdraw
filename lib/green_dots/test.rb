# frozen_string_literal: true

class GreenDots::Test
	extend GreenDots::Context

	class << self
		def run(run = GreenDots::Run.new)
			return unless @tests

			new(run).run(@tests)
		end

		def include_matcher(*args)
			args.each { |m| matchers << m }
		end

		def matchers
			@matchers ||= if superclass < GreenDots::Test
				superclass.matchers.dup
			else
				Concurrent::Set.new
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

	def expect(value = nil, &block)
		matchers = @matchers # we need this to be a local variable because it's used in the block below
		expectation_class = GreenDots::EXPECTATION_SHAPES[matchers] ||= Class.new(GreenDots::Expectation) do
			matchers.each { include _1 }
			freeze
		end

		location = caller_locations(1, 1).first

		expectation = expectation_class.new(self, value, &block)

		@expectations << expectation
		expectation
	end

	def resolve
		@expectations.each(&:resolve)
	ensure
		@expectations.clear
	end

	def assert(value = nil, &block)
		expect(value, &block).truthy?
	end

	def refute(value = nil, &block)
		expect(value, &block).falsy?
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
