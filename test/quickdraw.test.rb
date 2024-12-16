# frozen_string_literal: true

test "assert" do
	assert true
end

test "assert", skip: true do
	assert false
end

test "refute" do
	refute false
end

test "refute", skip: true do
	refute true
end
