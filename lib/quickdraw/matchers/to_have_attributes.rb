# frozen_string_literal: true

module Quickdraw::Matchers::ToHaveAttributes
	def to_have_attributes(**attributes)
		attributes.each do |k, v|
			assert v === @subject.__send__(k) do
				"expected `#{@subject.inspect}` to have the attribute `#{k.inspect}` equal to `#{v.inspect}`"
			end
		end
	rescue NoMethodError => e
		failure!(depth: 1) { "expected `#{@subject.inspect}` to respond to `#{e.name}`" }
	end
end
