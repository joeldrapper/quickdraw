# frozen_string_literal: true

require "matchers/pass_fail"
require "simplecov"

module BazMatcher
	def baz?
		success!
	end
end

GreenDots.configure do
	matcher Matchers::PassFail, Proc
	matcher BazMatcher, String
end

SimpleCov.start
