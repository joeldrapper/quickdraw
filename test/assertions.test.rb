# frozen_string_literal: true

test "assert_equal" do
	assert_equal 1, 1
end

test "assert_raises" do
	error = assert_raises(ArgumentError) do
		raise ArgumentError.new("Test")
	end

	match { error => ArgumentError }
	assert_equal error.message, "Test"
end

test "assert_respond_to" do
	assert_respond_to 1, :even?
end
