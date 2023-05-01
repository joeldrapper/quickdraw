# frozen_string_literal: true

module GreenDots::Context
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
end
