# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in quickdraw.gemspec
gemspec

gem "rspec-expectations"
gem "minitest"

if RUBY_ENGINE == "ruby"
	group :development do
		gem "rubocop"
		gem "sus"
		gem "covered"
	end
end
