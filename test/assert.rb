# frozen_string_literal: true

test "assert with falsy value" do
	expect {
		Class.new(GreenDots::Test) do
			test { assert false }
		end.run
	}.to_raise GreenDots::TestFailure do |error|
		expect(error.message) == "Expected false to be truthy."
	end
end

test "assert with truthy value" do
	expect {
		Class.new(GreenDots::Test) do
			test { assert true }
		end.run
	}.to_not_raise
end
