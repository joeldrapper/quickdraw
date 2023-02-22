# frozen_string_literal: true

test "with falsy expression" do
	expect {
		Class.new(GreenDots::Test) do
			test { assert false }
		end.run
	}.to_raise GreenDots::TestFailure do |error|
		expect(error.message) == "Expected false to be truthy."
	end
end

test "with truthy expression" do
	expect {
		Class.new(GreenDots::Test) do
			test { assert true }
		end.run
	}.to_not_raise
end
