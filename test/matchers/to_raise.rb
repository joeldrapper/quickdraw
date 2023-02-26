# frozen_string_literal: true

test "with a block that doesn't raise" do
	expect {
		Class.new(GreenDots::Test) do
			test { expect { 1 }.to_raise }
		end.run
	}.to_raise(GreenDots::TestFailure) do |error|
		expect(error.message) == "Expected Exception to be raised but wasn't."
	end
end

test "with a block that raises" do
	expect {
		Class.new(GreenDots::Test) do
			test { expect { raise }.to_raise }
		end.run
	}.to_not_raise
end
