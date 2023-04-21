# frozen_string_literal: true

describe "truthy?" do
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
end

describe "falsy?" do
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
end
