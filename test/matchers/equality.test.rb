# frozen_string_literal: true

test "==" do
	expect {
		test { expect(1) == 1 }
	}.to_pass

	expect {
		test { expect(1) == 2 }
	}.to_fail(message: %(expected `1` to == `2`))
end

test "!=" do
	expect {
		test { expect(1) != 2 }
	}.to_pass

	expect {
		test { expect(1) != 1 }
	}.to_fail(message: %(expected `1` to != `1`))
end
