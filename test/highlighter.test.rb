# frozen_string_literal: true

test do
	puts GreenDots::Highlighter.highlight <<~RUBY

		def foo()
			baz = 1
			puts baz

			@name = "hello"
		end

	RUBY
end
