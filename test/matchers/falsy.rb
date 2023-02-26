# frozen_string_literal: true

test "with falsy" do
	expect {
		Class.new(GreenDots::Test) do
			test do
				expect(nil).falsy?
			end
		end.run
	}.to_not_raise
end

test "with truthy" do
	expect {
		Class.new(GreenDots::Test) do
			test do
				expect(1).falsy?
			end
		end.run
	}.to_raise(GreenDots::TestFailure) do |error|
		expect(error.message) == %(Expected 1 to be falsy.)
	end
end
