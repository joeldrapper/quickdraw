# frozen_string_literal: true

extend Quickdraw::RSpec

describe Quickdraw::RSpec do
	context "whatever" do
		let(:a) { "a" }

		it "works" do
			expect([1, 2, 3]).to include(1)

			expect {
				throw(:baz)
			}.to throw_symbol(:baz)
		end
	end
end
