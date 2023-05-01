# frozen_string_literal: true

require "matchers/pass_fail"
require "matchers/html"
require "simplecov"

module BazMatcher
	def baz?
		success!
	end
end

GreenDots.configure do |config|
	config.register_matcher Matchers::PassFail, Proc
	config.register_matcher BazMatcher, String
	config.register_matcher Matchers::HTML, Nokolexbor::Document
end

SimpleCov.start
