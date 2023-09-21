# frozen_string_literal: true

User = Data.define(:name)

test "success" do
	expect {
		test {
			expect(User.new(name: "Joel")).to_have_attributes(
				name: "Joel"
			)
		}
	}.to_pass
end

test "failure with wrong value" do
	expect {
		test {
			expect(User.new(name: "Joel")).to_have_attributes(
				name: "Jill"
			)
		}
	}.to_fail message: %(expected `#<data name="Joel">` to have the attribute `:name` equal to `"Jill"`)
end

test "failure with missing reader method" do
	expect {
		test {
			expect(User.new(name: "Joel")).to_have_attributes(
				email: "joel@drapper.me"
			)
		}
	}.to_fail message: %(expected `#<data name="Joel">` to respond to `email`)
end
