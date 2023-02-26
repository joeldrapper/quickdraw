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

test "yieldsd the exception to the block" do
	exception = nil

	Class.new(GreenDots::Test) do
		test do
			expect { raise ArgumentError }.to_raise(ArgumentError) do |error|
				exception = error
			end
		end
	end.run

	expect(exception.class) == ArgumentError
end

describe "expcting a specific exception" do
	test "with a block that raises the expected exception" do
		expect {
			Class.new(GreenDots::Test) do
				test { expect { raise ArgumentError }.to_raise(ArgumentError) }
			end.run
		}.to_not_raise
	end

	test "with a block that raises a different exception" do
		expect {
			Class.new(GreenDots::Test) do
				test { expect { raise ArgumentError }.to_raise(NameError) }
			end.run
		}.to_raise(GreenDots::TestFailure) do |error|
			expect(error.message) == "Expected `NameError` to be raised but `ArgumentError` was raised."
		end
	end
end
