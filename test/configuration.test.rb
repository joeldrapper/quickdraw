# frozen_string_literal: true

test "has a registry" do
	configuration = Quickdraw::Configuration.new
	expect(configuration.registry).to_be_a Quickdraw::Registry
end
