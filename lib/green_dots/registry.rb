# frozen_string_literal: true

class GreenDots::Registry
	def initialize
		@registered_matchers = Concurrent::Hash.new
		@type_matchers = Concurrent::Map.new
		@shapes = Concurrent::Map.new
	end

	def register(matcher, *types)
		@registered_matchers[matcher] = types
		@type_matchers.clear
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
			matchers.each { |m| include m }
			freeze
		end
	end

	def matchers_for(value)
		@type_matchers[value.class] ||= slowly_find_matchers_for(value)
	end

	def slowly_find_matchers_for(value)
		@registered_matchers.map do |matcher, types|
			matcher if types.any? { |t| t === value }
		end.compact!
	end
end
