# frozen_string_literal: true

class GreenDots::Context
	DEFAULT_MATCHERS = [
		GreenDots::Matchers::ToBeA,
		GreenDots::Matchers::Boolean,
		GreenDots::Matchers::ToRaise,
		GreenDots::Matchers::Equality,
		GreenDots::Matchers::ToReceive,
		GreenDots::Matchers::Predicate,
		GreenDots::Matchers::ToHaveAttributes
	].freeze

	class << self
		def run(run = GreenDots::Run.new)
			@sub_contexts&.each { |c| c.run(run) }

			new(run).run(@tests) if @tests
		end

		def use(*args)
			args.each { |m| matchers << m }
		end

		def matchers
			@matchers ||= if superclass < GreenDots::Context
				superclass.matchers.dup
			else
				Concurrent::Set.new(DEFAULT_MATCHERS)
			end
		end

		def describe(description = nil, &block)
			(@sub_contexts ||= Concurrent::Array.new) << Class.new(self, &block)
		end

		alias_method :context, :describe

		def test(name = nil, skip: false, &block)
			(@tests ||= Concurrent::Array.new) << {
				name: name,
				block: block,
				skip: skip
			}
		end

		def let(method_name)
			original_method = instance_method(method_name)
			ivar_name = :"@#{method_name}"

			define_method(method_name) do
				if instance_variable_defined?(ivar_name)
					instance_variable_get(ivar_name)
				else
					instance_variable_set(ivar_name, original_method.bind(self).call)
				end
			end

			method_name
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

	def expect(subject = GreenDots::Null, &block)
		type = GreenDots::Null == subject ? block : subject

		expectation_class = GreenDots::CONFIGURATION.registry.expectation_for(type, matchers: @matchers)

		# location = caller_locations(1, 1).first

		expectation = expectation_class.new(self, subject, &block)

		@expectations << expectation
		expectation
	end

	def resolve
		@expectations.each(&:resolve)
	ensure
		@expectations.clear
	end

	def assert(subject, &block)
		block ||= -> { "Expected #{subject.inspect} to be truthy." }
		subject ? success! : failure!(block.call)
	end

	def refute(subject, &block)
		block ||= -> { "Expected #{subject.inspect} to be falsy." }
		subject ? failure!(block.call) : success!
	end

	def success!
		if @skip
			@run.failure! "The skipped test `#{@name}` started passing."
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
