# frozen_string_literal: true

describe "to_be_truthy" do
	test "with truthy" do
		expect {
			test { expect(1).to_be_truthy }
		}.to_pass
	end

	test "with falsy" do
		expect {
			test { expect(nil).to_be_truthy }
		}.to_fail message: %(Expected nil to be truthy.)
	end
end

describe "to_be_falsy" do
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
end
