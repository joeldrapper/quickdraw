# frozen_string_literal: true

test "to_be success" do
	expect {
		test { expect(nil).to_be :nil? }
	}.to_pass
end

test "to_be failure" do
	expect {
		test { expect(1).to_be :nil? }
	}.to_fail message: "Expected `1` to be `nil?`."
end

test "not_to_be success" do
	expect {
		test { expect(1).not_to_be :nil? }
	}.to_pass
end

test "not_to_be failure" do
	expect {
		test { expect(nil).not_to_be :nil? }
	}.to_fail message: "Expected `nil` to not be `nil?`."
end
