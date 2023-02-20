# frozen_string_literal: true

class GreenDots::Expectation < BasicObject
	def initialize(context, expression = nil, &block)
		__raise__ ::ArgumentError, "You need to provide an expression or block to `expect`." unless expression || block
		__raise__ ::ArgumentError, "You can only provide an expression or a block to `expect`." if expression && block

		@context, @expression, @block = context, expression, block
	end

	define_method :__raise__, ::Object.instance_method(:raise)
	define_method :__block_given__?, ::Object.instance_method(:block_given?)

	def ==(other)
		__raise__ ::ArgumentError, "You can't use the `==` matcher with a block expectation." if @block
		@expression == other ? success : @result = "Expected #{@expression} to == #{other}"
	end

	def !=(other)
		__raise__ ::ArgumentError, "You can't use the `!=` matcher with a block expectation." if @block
		@expression == other ? @result = "Expected #{@expression} to != #{other}" : success
	end

	def to_raise(error = ::Exception)
		@result = "Expected #{error} to be raised but wasn't."
		@block.call
	rescue ::Exception => e
		if e.is_a? error
			success
			yield(e) if __block_given__?
		else
			@result = "Expected an #{error} but got a #{e.class}(#{e})"
		end
	end

	def to_not_raise
		@block.call
		success
	rescue ::Exception => e
		@result = "Expected not to raise, but raised #{e.class}(#{e})"
	end

	def truthy?
		__raise__ ::ArgumentError, "You can't use the `truthy?` matcher with a block expectation." if @block
		@expression ? success : @result = "Expected #{@expression} to be truthy."
	end

	def falsy?
		__raise__ ::ArgumentError, "You can't use the `falsy?` matcher with a block expectation." if @block
		@expression ? @result = "Expected #{@expression} to be truthy." : success
	end

	def to_receive(method_name, &expectation_block)
		__raise__ ::ArgumentError, "You can't use the `to_receive` matcher with a block expectation." if @block
		@result = "Expected #{@expression} to receive #{method_name}"
		interceptor = ::Module.new

		# Make these available from the block
		expectation = self
		context = @context

		interceptor.define_method(method_name) do |*args, **kwargs, &block|
			expectation.success

			begin
				original_super = context.instance_variable_get(:@super)
				context.instance_variable_set(:@super, -> { super(*args, **kwargs, &block) })
				result = expectation_block&.call(*args, **kwargs, &block)
			ensure
				context.instance_variable_set(:@super, original_super)
			end

			interceptor.define_method(method_name) { |*a, **k, &b| super(*a, **k, &b) }
			result
		end

		@expression.singleton_class.prepend(interceptor)
	end

	def success
		@result = true
	end

	def resolve
		@result == true ? ::GreenDots.success : __raise__(@result)
	end
end
