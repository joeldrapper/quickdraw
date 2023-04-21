# frozen_string_literal: true

include_matcher Matchers::PassFail

describe "==" do
	test "when equal" do
		expect {
			test { expect("a") == "a" }
		}.to_pass
	end

	test "when not equal" do
		expect {
			test { expect("a") == "b" }
		}.to_fail message: %(Expected "a" to == "b".)
	end
end

describe "!=" do
	test "when not equal" do
		expect {
			test { expect("a") != "b" }
		}.to_pass
	end

	test "when equal" do
		expect {
			test { expect("a") != "a" }
		}.to_fail message: %(Expected "a" to != "a".)
	end
end
