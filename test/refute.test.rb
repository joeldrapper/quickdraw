# frozen_string_literal: true

test "refute with falsy value" do
	expect {
		Class.new(GreenDots::Context) do
			test { refute false }
		end.run
	}.not_to_raise
end

# test do
# 	assert false
# end

test "refute with truthy value" do
	expect {
		Class.new(GreenDots::Context) do
			test { refute true }
		end.run
	}.to_raise(GreenDots::TestFailure) do |error|
		expect(error.message) == "Expected true to be falsy."
	end
end
