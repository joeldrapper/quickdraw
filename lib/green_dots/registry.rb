# frozen_string_literal: true

class GreenDots::Registry
	def initialize
		@registered_matchers = GreenDots::Map.new
		@type_matchers = GreenDots::Map.new
		@shapes = GreenDots::Map.new
		@hash = @registered_matchers.hash
	end

	def register(matcher, *types)
		@registered_matchers[matcher] = types
	end

	def expectation_for(value, matchers: nil)
		if matchers
			shape_for(
				matchers + matchers_for(value)
			)
		else
			shape_for(
				matchers_for(value)
			)
		end
	end

	private

	def shape_for(matchers)
		@shapes[matchers] ||= Class.new(GreenDots::Expectation) do
			matchers.each { include _1 if _1 }
			freeze
		end
	end

	def matchers_for(value)
		check_cache!

		@type_matchers[value.class] ||= Array.new(
			find_matchers_for(value)
		)
	end

	def check_cache!
		unless @registered_matchers.hash == @hash
			@hash = @registered_matchers.hash
			@type_matchers.clear
		end
	end

	def find_matchers_for(value)
		@registered_matchers.map do |matcher, types|
			matcher if types.any? { |t| t === value }
		end
	end
end
