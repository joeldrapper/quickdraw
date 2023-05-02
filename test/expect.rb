# frozen_string_literal: true

test "raises without an expectation" do
	expect {
		Class.new(GreenDots::Context) do
			test { expect(1) }
		end.run
	}.to_raise(GreenDots::TestFailure) do |error|
		expect(error.message) == "You didn't make any expectations."
	end
end

test "raises when a block matcher is given a value" do
	expect {
		Class.new(GreenDots::Context) do
			test { expect(1).to_raise }
		end.run
	}.to_raise(GreenDots::ArgumentError) do |error|
		expect(error.message) == "You must pass a block rather than a subject when using the to_raise matcher."
	end
end

test "raises when a value matcher is given a block" do
	expect {
		Class.new(GreenDots::Context) do
			test { expect { 1 } == 1 }
		end.run
	}.to_raise(GreenDots::ArgumentError) do |error|
		expect(error.message) == "You must pass a subject rather than a block when using the == matcher."
	end
end

test "skipped tests fail when they start passing" do
	expect {
		test("foo", skip: true) { expect(1) == 1 }
	}.to_fail message: "The skipped test `foo` started passing."
end
