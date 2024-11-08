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
	}.to_fail message: "expected false to be truthy", location: [__FILE__, __LINE__ - 1]
end

test "assert with truthy value" do
	expect {
		test { assert true }
	}.to_pass
end

test "assert with custom failure message" do
	expect {
		test { assert(false) { "Message" } }
	}.to_fail message: "Message", location: [__FILE__, __LINE__ - 1]
end

test "assert with custom message raising an error" do
	expect {
		test { assert(false) { raise ArgumentError } }
	}.to_error
end
