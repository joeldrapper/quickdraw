# frozen_string_literal: true

test "with falsy" do
	expect {
		test { expect(nil).falsy? }
	}.to_pass
end

test "with truthy" do
	expect {
		test { expect(1).falsy? }
	}.to_fail message: %(Expected 1 to be falsy.)
end
