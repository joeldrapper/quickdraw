# frozen_string_literal: true

test "#to_be_truthy with truthy" do
	expect {
		test { expect(1).to_be_truthy }
	}.to_pass
end

test "#to_be_truthy with falsy" do
	expect {
		test { expect(nil).to_be_truthy }
	}.to_fail message: %(expected `nil` to be truthy)
end

test "#to_be_falsy with falsy" do
	expect {
		test { expect(nil).to_be_falsy }
	}.to_pass
end

test "#to_be_falsy with truthy" do
	expect {
		test { expect(1).to_be_falsy }
	}.to_fail message: %(expected `1` to be falsy)
end
