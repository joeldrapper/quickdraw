# frozen_string_literal: true

module GreenDots::Matchers::ToHaveAttributes
	def to_have_attributes(**attributes)
		attributes.each do |k, v|
			assert v === value.send(k) do
				"expected `#{value.inspect}` to have the attribute `#{k.inspect}` equal to `#{v.inspect}`"
			end
		end
	rescue NoMethodError => e
		failure! { "expected `#{value.inspect}` to respond to `#{e.name}`" }
	end
end
