# frozen_string_literal: true

extend Quickdraw::RSpec

RSpec.describe Quickdraw::RSpec do
	describe "foo" do
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

	describe "unnamed subject" do
		subject { "subj" }

		it "works when referenced as 'subject'" do
			expect(subject) == "subj"
		end
	end

	describe "named subject" do
		subject(:named_subject) { "subj" }

		it "works when referenced as 'subject'" do
			expect(subject) == "subj"
		end

		it "works when referenced by its name" do
			expect(named_subject) == "subj"
		end
	end
end
