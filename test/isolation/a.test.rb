# frozen_string_literal: true

class Example
	def a
		"a"
	end
end

test do
	expect(Example.new).to_respond_to(:a)
	expect(Example.new).not_to_respond_to(:b)
end
