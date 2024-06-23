# frozen_string_literal: true

class Example
	def b
		"b"
	end
end

test do
	expect(Example.new).to_respond_to(:b)
	expect(Example.new).not_to_respond_to(:a)
end
