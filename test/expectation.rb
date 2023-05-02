# frozen_string_literal: true

test do
	expect {
		Class.new(GreenDots::Context) do
			test { expect(1) { 2 } }
		end.run
	}.to_raise(GreenDots::ArgumentError) do |error|
		expect(error.message) == "You can only provide a subject or a block to `expect`."
	end
end
