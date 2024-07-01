# frozen_string_literal: true

module Quickdraw::Matchers::Equality
	def ==(other)
		assert @subject == other do
			"expected `#{@subject.inspect}` to == `#{other.inspect}`"
		end
	end

	def !=(other)
		assert @subject != other do
			"expected `#{@subject.inspect}` to != `#{other.inspect}`"
		end
	end

	def ===(other)
		assert @subject === other do
			"expected `#{@subject.inspect}` to === `#{other.inspect}`"
		end
	end

	def =~(other)
		assert @subject =~ other do
			"expected `#{@subject.inspect}` to =~ `#{other.inspect}`"
		end
	end

	def >(other)
		assert @subject > other do
			"expected `#{@subject.inspect}` to be > `#{other.inspect}`"
		end
	end

	def <(other)
		assert @subject < other do
			"expected `#{@subject.inspect}` to be < `#{other.inspect}`"
		end
	end

	def <=(other)
		assert @subject <= other do
			"expected `#{@subject.inspect}` to be <= `#{other.inspect}`"
		end
	end

	def >=(other)
		assert @subject >= other do
			"expected `#{@subject.inspect}` to be >= `#{other.inspect}`"
		end
	end

	def to_eql?(other)
		assert @subject.eql?(other) do
			"expected `#{@subject.inspect}` to eql? `#{other.inspect}`"
		end
	end

	def not_to_eql?(other)
		refute @subject.eql?(other) do
			"expected `#{@subject.inspect}` not to eql? `#{other.inspect}`"
		end
	end

	def to_equal?(other)
		assert @subject.equal?(other) do
			"expected `#{@subject.inspect}` to equal? `#{other.inspect}`"
		end
	end

	def not_to_equal?(other)
		refute @subject.equal?(other) do
			"expected `#{@subject.inspect}` not to equal? `#{other.inspect}`"
		end
	end
end
