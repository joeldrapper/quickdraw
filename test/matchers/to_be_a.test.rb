# frozen_string_literal: true

test "positive case failure" do
	expect {
		test { expect(1).to_be_a String }
	}.to_fail message: "expected `1` to have the type `String`"
end

test "positive case success" do
	expect {
		test { expect(1).to_be_an Integer }
	}.to_pass
end

test "negative case failure" do
	expect {
		test { expect(1).not_to_be_an Integer }
	}.to_fail message: "expected `1` to not have the type `Integer`"
end

test "negative case success" do
	expect {
		test { expect(1).not_to_be_a String }
	}.to_pass
end
