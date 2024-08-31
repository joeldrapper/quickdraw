# frozen_string_literal: true

class Quickdraw::Never < BasicObject
	def initialize(message)
		@message = message
	end

	def method_missing(method_name, ...)
		::Kernel.raise(
				::ArgumentError.new(@message),
			)
	end
end
