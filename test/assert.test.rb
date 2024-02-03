# frozen_string_literal: true

use Matchers::PassFail

# test "something interesting" do
# 	expect(
# 		false
# 	).to_be_truthy
# end

test "assert with falsy value" do
	expect {
		test { assert false }
	}.to_fail message: "expected false to be truthy"
end

test "assert with truthy value" do
	expect {
		Class.new(GreenDots::Context) do
			test { assert true }
		end.run
	}.not_to_raise
end

test "assert with custom failure message" do
	expect {
		test { assert(false) { "Message" } }
	}.to_fail message: "Message"
end
