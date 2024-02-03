# frozen_string_literal: true

describe GreenDots::Configuration do
	test "has a registry" do
		configuration = GreenDots::Configuration.new
		expect(configuration.registry).to_be_a GreenDots::Registry
	end
end
