# frozen_string_literal: true

test "with truthy" do
	expect {
		Class.new(GreenDots::Test) do
			test { expect(1).truthy? }
		end.run
	}.to_not_raise
end

test "with falsy" do
	expect {
		Class.new(GreenDots::Test) do
			test { expect(nil).truthy? }
		end.run
	}.to_raise(GreenDots::TestFailure) do |error|
		expect(error.message) == %(Expected nil to be truthy.)
	end
end
