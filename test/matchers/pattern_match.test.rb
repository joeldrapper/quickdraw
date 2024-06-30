# frozen_string_literal: true

test "when equal" do
	expect {
		test { expect("a") =~ /a/ }
	}.to_pass
end

test "when not equal" do
	expect {
		test { expect("a") =~ /b/ }
	}.to_fail message: %(expected `"a"` to =~ `"/b/"`)
end
