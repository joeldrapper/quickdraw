# frozen_string_literal: true

module Quickdraw::Matchers::Boolean
	def to_be_truthy
		assert(@subject) { "expected `#{@subject.inspect}` to be truthy" }
	end

	def to_be_falsy
		refute(@subject) { "expected `#{@subject.inspect}` to be falsy" }
	end
end
