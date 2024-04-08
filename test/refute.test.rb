# frozen_string_literal: true

test "refute with falsy value" do
	expect {
		test { refute false }
	}.to_pass
end

test "refute with truthy value" do
	expect {
		test { refute true }
	}.to_fail
end
