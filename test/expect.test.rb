# frozen_string_literal: true

test "raises without an expectation" do
	expect {
		test { expect(1) }
	}.to_fail message: "You didn't make any expectations."
end

test "skipped tests fail when they start passing" do
	expect {
		test("foo", skip: true) { expect(1) == 1 }
	}.to_fail message: "The skipped test `foo` started passing."
end
