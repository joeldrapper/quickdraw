# frozen_string_literal: true

include_matcher Matchers::PassFail

test "with truthy" do
	expect {
		test { expect(1).truthy? }
	}.to_pass
end

test "with falsy" do
	expect {
		test { expect(nil).truthy? }
	}.to_fail message: %(Expected nil to be truthy.)
end
