# frozen_string_literal: true

describe "==" do
	test "when equal" do
		expect {
			Class.new(GreenDots::Test) do
				test do
					expect("a") == "a"
				end
			end.run
		}.to_not_raise
	end

	test "when not equal" do
		expect {
			Class.new(GreenDots::Test) do
				test do
					expect("a") == "b"
				end
			end.run
		}.to_raise(GreenDots::TestFailure) do |error|
			expect(error.message) == %(Expected "a" to == "b".)
		end
	end
end

describe "!=" do
	test "when not equal" do
		expect {
			Class.new(GreenDots::Test) do
				test do
					expect("a") != "b"
				end
			end.run
		}.to_not_raise
	end

	test "when equal" do
		expect {
			Class.new(GreenDots::Test) do
				test do
					expect("a") != "a"
				end
			end.run
		}.to_raise(GreenDots::TestFailure) do |error|
			expect(error.message) == %(Expected "a" to != "a".)
		end
	end
end
