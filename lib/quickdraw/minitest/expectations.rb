# frozen_string_literal: true

module Quickdraw::Minitest::Expectations
	def must_be(method_name, *args)
		assert(@subject.public_send(method_name, *args)) do
			"expected #{@subject.inspect} to match #{method_name}(#{args.map(&:inspect).join(', ')})"
		end
	end

	def wont_be(method_name, *args)
		refute(@subject.public_send(method_name, *args)) do
			"expected #{@subject.inspect} to not match #{method_name}(#{args.map(&:inspect).join(', ')})"
		end
	end
end
