# frozen_string_literal: true

require_relative "lib/green_dots/version"

Gem::Specification.new do |spec|
	spec.name = "green_dots"
	spec.version = GreenDots::VERSION
	spec.authors = ["Joel Drapper"]
	spec.email = ["joel@drapper.me"]

	spec.summary = "Experimental test framework"
	spec.description = "Experimental test framework"
	spec.homepage = "https://github.com/joeldrapper/green_dots"
	spec.license = "MIT"
	spec.required_ruby_version = ">= 2.7"

	spec.metadata["homepage_uri"] = spec.homepage
	spec.metadata["source_code_uri"] = "https://github.com/joeldrapper/green_dots"
	spec.metadata["changelog_uri"] = "https://github.com/joeldrapper/green_dots"

	# Specify which files should be added to the gem when it is released.
	# The `git ls-files -z` loads the files in the RubyGem that have been added into git.
	spec.files = Dir.chdir(__dir__) do
		`git ls-files -z`.split("\x0").reject do |f|
			(f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
		end
	end
	spec.bindir = "exe"
	spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
	spec.require_paths = ["lib"]

	# Uncomment to register a new dependency of your gem
	spec.add_dependency "concurrent-ruby"
	spec.add_dependency "zeitwerk"
	spec.add_dependency "async"

	# For more information and examples about making a new gem, check out our
	# guide at: https://bundler.io/guides/creating_gem.html
	spec.metadata["rubygems_mfa_required"] = "true"
end
