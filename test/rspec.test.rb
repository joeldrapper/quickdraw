# frozen_string_literal: true

include Quickdraw::RSpecAdapter

describe String do
	describe "test" do
		it "works" do
			expect("Hello").to eq("Hello")
		end
	end
end
