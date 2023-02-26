require "green_dots"

test "with truthy" do
  expect {
    Class.new(GreenDots::Test) do
      test "truthy" do
        expect(1).truthy?
      end
    end.run
  }.to_not_raise
end

test "with falsy" do
  expect {
    Class.new(GreenDots::Test) do
      test "truthy" do
        expect(nil).truthy?
      end
    end.run
  }.to_raise(GreenDots::TestFailure) do |error|
    expect(error.message) == %(Expected nil to be truthy.)
  end
end
