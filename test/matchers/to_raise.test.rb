# frozen_string_literal: true

test "with a block that doesn't raise" do
	expect {
		test { expect { 1 }.to_raise }
	}.to_fail(message: "expected Exception to be raised but wasn't")
end

test "with a block that raises" do
	expect {
		test { expect { raise }.to_raise }
	}.to_pass
end

test "with a specific exception" do
	expect {
		test { expect { raise ArgumentError }.to_raise(ArgumentError) }
	}.to_pass

	expect {
		test { expect { raise ArgumentError }.to_raise(NameError) }
	}.to_fail(message: "expected `NameError` to be raised but `ArgumentError` was raised")
end
