# GreenDots

### Assert

```ruby
test "something" do
  assert true
end
```

### Refute

```ruby
test "something" do
  refute false
end
```

### Expect matchers

### `==` and `!=`

```ruby
test "equality" do
  expect(Thing.foo) == "foo"
  expect(Thing.bar) != "foo"
end
```

### `to_raise`

```ruby
test "raises" do
  expect { Thing.bar! }.raises(ArgumentError) do |error|
    expect(error.message) == "Foo bar"
  end
end
```

### `to_receive`

```ruby
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
```

## Describe
You can optionally wrap tests in any number of `describe` blocks. `describe` is also aliased as `context`.

```ruby
describe Thing do
	test { assert true }
end