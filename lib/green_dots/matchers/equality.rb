# frozen_string_literal: true

module GreenDots::Matchers::Equality
	def ==(other)
		assert value == other do
			"Expected `#{value.inspect}` to == `#{other.inspect}`."
		end
	end

	def !=(other)
		assert value != other do
			"Expected `#{value.inspect}` to != `#{other.inspect}`."
		end
	end

	def to_eql?(other)
		assert value.eql?(other) do
			"Expected `#{value.inspect}` to eql? `#{other.inspect}`."
		end
	end

	def not_to_eql?(other)
		refute value.eql?(other) do
			"Expected `#{value.inspect}` not to eql? `#{other.inspect}`."
		end
	end

	def to_equal?(other)
		assert value.equal?(other) do
			"Expected `#{value.inspect}` to equal? `#{other.inspect}`."
		end
	end

	def not_to_equal?(other)
		refute value.equal?(other) do
			"Expected `#{value.inspect}` not to equal? `#{other.inspect}`."
		end
	end
end
