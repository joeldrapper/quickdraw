# frozen_string_literal: true

include Quickdraw::RSpecAdapter

describe String do
	describe "test" do
		let(:example) { "Hello" }
		subject { "Hello" }

		it "works" do
			expect(example).to eq(subject)
		end
	end
end
