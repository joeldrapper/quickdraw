module Quickdraw::Minitest
	def self.extended(base)
		base.include(Assertions)
	end

	def skip(*, **, &)
		test(*, **, skip: true, &)
	end

	module Assertions
		def assert(a, b = nil)
			if b
				super(a) { b }
			else
				super(a)
			end
		end

		def assert_equal(expected, actual)
			assert(expected == actual) do
				"Expected #{expected} to be equal to #{actual}"
			end
		end
	end
end
