# frozen_string_literal: true

# < BasicObject
class GreenDots::Expectation
	def initialize(context, expression = nil, &block)
		if expression && block
			__raise__ ::ArgumentError, "You can only provide an expression or a block to `expect`."
		end

		@context = context
		@expression = expression
		@block = block
	end

	define_method :__raise__, ::Object.instance_method(:raise)
	define_method :__block_given__?, ::Object.instance_method(:block_given?)

	def ==(other)
		assert(expression == other) { "Expected #{@expression} to == #{other}." }
	end

	def !=(other)
		assert(expression != other) { "Expected #{@expression} to != #{other}" }
	end

	def to_raise(error = ::Exception)
		@result = "Expected #{error} to be raised but wasn't."
		block.call
	rescue ::Exception => e
		if e.is_a? error
			success!
			yield(e) if __block_given__?
		else
			@result = "Expected an #{error} but got a #{e.class}(#{e})"
		end
	end

	def to_not_raise
		block.call
		success!
	rescue ::Exception => e
		@result = "Expected not to raise, but raised #{e.class}(#{e})"
	end

	def truthy?
		assert(expression) { "Expected #{@expression} to be truthy." }
	end

	def falsy?
		refute(expression) { "Expected #{@expression} to be truthy." }
	end

	def to_receive(method_name, &expectation_block)
		__raise__ ::ArgumentError, "You can't use the `to_receive` matcher with a block expectation." if @block

		@result = "Expected #{@expression} to receive #{method_name}"

		interceptor = ::Module.new

		# Make these available from the block
		expectation = self
		context = @context

		interceptor.define_method(method_name) do |*args, **kwargs, &block|
			expectation.success!
			super_block = -> (*a, &b) { (a.length > 0) || b ? super(*a, &b) : super(*args, **kwargs, &block) }
			original_super = context.instance_variable_get(:@super)
			begin
				context.instance_variable_set(:@super, super_block)
				result = expectation_block&.call(*args, **kwargs, &block)
			ensure
				context.instance_variable_set(:@super, original_super)
			end

			interceptor.define_method(method_name) { |*a, **k, &b| super(*a, **k, &b) }
			result
		end

		@expression.singleton_class.prepend(interceptor)
	end

	def success!
		@result = true
	end

	def resolve
		case @result
		when nil
			@context.error! "You didn't make any expectations."
		when true
			@context.success!
		else
			@context.error!(@result)
		end
	end

	private

	def expression
		if @block
			__raise__ ::ArgumentError,
				"You must pass an expression rather than a block when using the #{caller_locations.first.label} matcher."
		else
			@expression
		end
	end

	def block
		@block || __raise__(::ArgumentError, "You must pass a block rather than an expression when using the #{caller_locations.first.label} matcher.")
	end

	def assert(expression)
		expression ? success! : @result = yield
	end

	def refute(expression)
		expression ? @result = yield : success!
	end
end
