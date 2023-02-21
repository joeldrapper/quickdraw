# frozen_string_literal: true

class GreenDots::Example
	class << self
		def test(name = nil, skip: false, &block)
			{
				name: name,
				block: block,
				skip: skip
			}.tap { (@tests ||= []) << _1 }
		end

		def skip(test, &block)
			test[:skip] = true
		end

		def context(description = nil, &block)
			Class.new(self, &block).run
		end

		def run
			return unless @tests

			new.run(@tests)
		end
	end

	attr_accessor :skip

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
		@expectations.clear
	end

	def assert(expression = nil, &block)
		expect(expression, &block).truthy?
	end

	def refute(expression = nil, &block)
		expect(expression, &block).falsy?
	end

	def success!
		@skip ? raise("Error") : GreenDots.success
	end

	def error!(message)
		@skip ? GreenDots.success : raise(message)
	end
end
