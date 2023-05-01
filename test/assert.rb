# frozen_string_literal: true

use Matchers::PassFail

test "assert with falsy value" do
	expect {
		Class.new(GreenDots::Context) do
			test { assert false }
		end.run
	}.to_raise GreenDots::TestFailure do |error|
		expect(error.message) == "Expected false to be truthy."
	end
end

test "assert with truthy value" do
	expect {
		Class.new(GreenDots::Context) do
			test { assert true }
		end.run
	}.to_not_raise
end

test "assert with custom failure message" do
	expect {
		test { assert(false) { "Message" } }
	}.to_fail message: "Message"
end
