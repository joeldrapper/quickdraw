# frozen_string_literal: true

GreenDots.describe GreenDots do
	test "assert" do
		expect {
			Class.new(GreenDots::Example) do
				test { assert false }
			end.run
		}.to_raise

		expect {
			Class.new(GreenDots::Example) do
				test { assert true }
			end.run
		}.to_not_raise
	end
end
