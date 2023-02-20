# frozen_string_literal: true

class GreenDots::Example
	class << self
		def test(name = nil, &block)
			(@tests ||= []) << block
		end

		def context(description = nil, &block)
			Class.new(self, &block).run
		end

		def run
			return unless @tests

			instance = new

			@tests.shuffle.each do |test|
				instance.instance_eval(&test)
				instance.resolve
			end
		end
	end

	def initialize
		@expectations = []
	end

	def expect(expression = nil, &block)
		expectation = GreenDots::Expectation.new(self, expression, &block)
		@expectations << expectation
		expectation
	end

	def resolve
		@expectations.each(&:resolve)
		@expectations.clear
	end

	def assert(expression = nil, &block)
		expect(expression, &block).truthy?
	end

	def refute(expression = nil, &block)
		expect(expression, &block).falsy?
	end
end
