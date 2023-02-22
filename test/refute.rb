# frozen_string_literal: true

test "with falsy expression" do
	expect {
		Class.new(GreenDots::Test) do
			test { refute false }
		end.run
	}.to_not_raise
end

test "with truthy expression" do
	expect {
		Class.new(GreenDots::Test) do
			test { refute true }
		end.run
	}.to_raise(GreenDots::TestFailure) do |error|
		expect(error.message) == "Expected true to be truthy."
	end
end
