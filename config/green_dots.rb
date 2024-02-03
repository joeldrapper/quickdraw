# frozen_string_literal: true

require_relative "../test/support/matchers/pass_fail"

module BazMatcher
	def baz?
		success!
	end
end

GreenDots.configure do |config|
	config.matcher Matchers::PassFail, Proc
	config.matcher BazMatcher, String
end

# SimpleCov.start
