# frozen_string_literal: true

class GreenDots::Test
	extend GreenDots::Context

	class << self
		def run
			return unless @tests

			new.run(@tests)
		end

		def include_matcher(*args)
			args.each { |matcher| matchers << matcher }
		end

		def matchers
			@matchers ||= if superclass < GreenDots::Test
				superclass.matchers.dup
			else
				Set.new
			end
		end
	end

	def initialize
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
			raise(GreenDots::TestFailure, "The skipped test \"#{@name}\" started passing.")
		else
			GreenDots.success
		end
	end

	def error!(message)
		if @skip
			GreenDots.success
		else
			raise(GreenDots::TestFailure, message)
		end
	end
end
