# frozen_string_literal: true

module GreenDots::Matchers::ToHaveAttributes
	def to_have_attributes(**attributes)
		attributes.each do |k, v|
			assert(value.send(k) == v) { "Expected `#{value.inspect}` to have the attribute `#{k.inspect}` equal to `#{v.inspect}`." }
		end
	rescue NoMethodError => e
		failure! { "Expected `#{value.inspect}` to respond to `#{e.name}`." }
	end
end
