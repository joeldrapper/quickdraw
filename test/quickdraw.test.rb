# frozen_string_literal: true

10_000.times do
	test do
		assert true
	end
end

test do
	refute false
	assert_equal 1, 2
end
