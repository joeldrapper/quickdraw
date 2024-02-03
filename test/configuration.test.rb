# frozen_string_literal: true

describe Quickdraw::Configuration do
	test "has a registry" do
		configuration = Quickdraw::Configuration.new
		expect(configuration.registry).to_be_a Quickdraw::Registry
	end
end
