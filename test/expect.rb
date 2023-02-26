# frozen_string_literal: true

test "raises without an expectation" do
	expect {
		Class.new(GreenDots::Test) do
			test { expect(1) }
		end.run
	}.to_raise(GreenDots::TestFailure) do |error|
		expect(error.message) == "You didn't make any expectations."
	end
end

test "raises when a block matcher is given an expression" do
	expect {
		Class.new(GreenDots::Test) do
			test { expect(1).to_raise }
		end.run
	}.to_raise(GreenDots::ArgumentError) do |error|
		expect(error.message) == "You must pass a block rather than an expression when using the to_raise matcher."
	end
end

test "raises when an expression matcher is given a block" do
	expect {
		Class.new(GreenDots::Test) do
			test { expect { 1 } == 1 }
		end.run
	}.to_raise(GreenDots::ArgumentError) do |error|
		expect(error.message) == "You must pass an expression rather than a block when using the == matcher."
	end
end
