# frozen_string_literal: true

test "refute with falsy value" do
	expect {
		Class.new(Quickdraw::Context) do
			test { refute false }
		end.run
	}.not_to_raise
end

test "refute with truthy value" do
	expect {
		test { refute true }
	}.to_fail
end
