# frozen_string_literal: true

class GreenDots::Registry
	def initialize
		@registered_matchers = Concurrent::Hash.new
		@type_matchers = Concurrent::Map.new
		@shapes = Concurrent::Map.new
	end

	# Register a new matcher for the given types.
	def register(matcher, *types)
		@registered_matchers[matcher] = types

		# We need to clear this cache because the output of `slowly_find_matchers_for` might have changed.
		@type_matchers.clear
	end

	# Given a value, find or build an expectation class that includes all the matchers for the value.
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

	# A "shape" is a specialised Expectation class that includes the given matchers. It's cached against the list of matchers.
	def shape_for(matchers)
		@shapes[matchers] ||= Class.new(GreenDots::Expectation) do
			matchers.each { |m| include m }
			freeze
		end
	end

	# Given a value, find all the matchers that match it. This is cached against the class of the value.
	def matchers_for(value)
		@type_matchers[value.class] ||= slowly_find_matchers_for(value)
	end

	# If the above has a cache miss, we'll need to find the correct matchers slowly and then cache them.
	def slowly_find_matchers_for(value)
		@registered_matchers.map do |matcher, types|
			matcher if types.any? { |t| t === value }
		end.compact! # no need to sort or uniquify for consistency here, as the registered_matchers are stored in a hash so they're already sorted and unique.
	end
end
