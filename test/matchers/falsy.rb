# frozen_string_literal: true

test "with falsy" do
	expect {
		test { expect(nil).to_be_falsy }
	}.to_pass
end

test "with truthy" do
	expect {
		test { expect(1).to_be_falsy }
	}.to_fail message: %(Expected 1 to be falsy.)
end
