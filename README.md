# GreenDots

### Assert

```ruby
GreenDots.describe Thing do
  test "something" do
    assert true
  end
end
```

### Refute

```ruby
GreenDots.describe Thing do
  test "something" do
    refute false
  end
end
```

### Expect

```ruby
GreenDots.describe Thing do
  test "equality" do
    expect(Thing.foo) == "foo"
    expect(Thing.bar) != "foo"
  end

  test "raises" do
    expect { Thing.bar! }.raises(ArgumentError) do |error|
      expect(error.message) == "Foo bar"
    end
  end

  test "mocks and spies" do
    expect(Thing).to_receive(:foo) do |a, b, c|
      # The block receives arguments and can make assertions about them.
      expect(a) == 1
      expect(b) != 1
      assert(c)

      # Either return a mock response or call the original via `@super`
      @super.call
    end

    Thing.foo(1, 2, 3)
  end
end
```
