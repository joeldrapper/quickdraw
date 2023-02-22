# frozen_string_literal: true

class GreenDots::Test
	extend GreenDots::Context

	def self.run
		return unless @tests

		new.run(@tests)
	end

	def initialize
		@expectations = []
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

	def expect(expression = nil, &block)
		expectation = GreenDots::Expectation.new(self, expression, &block)
		@expectations << expectation
		expectation
	end

	def resolve
		@expectations.each(&:resolve)
	ensure
		@expectations.clear
	end

	def assert(expression = nil, &block)
		expect(expression, &block).truthy?
	end

	def refute(expression = nil, &block)
		expect(expression, &block).falsy?
	end

	def success!
		@skip ? raise(GreenDots::FileTest, "Skipped test started passing.") : GreenDots.success
	end

	def error!(message)
		@skip ? GreenDots.success : raise(GreenDots::TestFailure, message)
	end
end
