# frozen_string_literal: true

describe "to_raise" do
	test "with a block that doesn't raise" do
		expect {
			test { expect { 1 }.to_raise }
		}.to_fail message: "expected Exception to be raised but wasn't"
	end

	test "with a block that raises" do
		expect {
			test { expect { raise }.to_raise }
		}.to_pass
	end

	test "yieldsd the exception to the block" do
		exception = nil

		Class.new(GreenDots::Context) do
			test do
				expect { raise ArgumentError }.to_raise(ArgumentError) do |error|
					exception = error
				end
			end
		end.run(GreenDots::Result.new)

		expect(exception).to_be_an ArgumentError
	end

	describe "expcting a specific exception" do
		test "with a block that raises the expected exception" do
			expect {
				test { expect { raise ArgumentError }.to_raise(ArgumentError) }
			}.to_pass
		end

		test "with a block that raises a different exception" do
			expect {
				test { expect { raise ArgumentError }.to_raise(NameError) }
			}.to_fail message: "expected `NameError` to be raised but `ArgumentError` was raised"
		end
	end
end

describe "not_to_raise" do
	test do
		expect {
			test { expect { 1 }.not_to_raise }
		}.to_pass
	end

	test do
		expect {
			test { expect { raise }.not_to_raise }
		}.to_fail message: "expected the block not to raise, but it raised `RuntimeError`"
	end
end
