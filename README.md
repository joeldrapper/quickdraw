# GreenDots

Your test files are executed in an anonymous class, so you can define methods and constants at the top level, without collisions.

### `.describe`
You can optionally wrap tests in any number of `describe` blocks. `describe` is also aliased as `context`. The describe block might not be necessary though and the name of the file might be enough.

```ruby
describe Thing do
  test "something" do
    assert true
  end
end
```

### `.test`
The test description is optional — sometimes you don't need a description.

```ruby
test { assert true }
```

You can pass `skip: true` to skip the test. Skipped tests are still run and will fail if they start passing.

```ruby
test(skip: true) { assert false }
```

### `#assert`

```ruby
test "something" do
  assert true
end
```

### `#refute`

```ruby
test "something" do
  refute false
end
```

### `expect` matchers

#### `==` and `!=`

```ruby
test "equality" do
  expect(Thing.foo) == "foo"
  expect(Thing.bar) != "foo"
end
```

#### `to_raise`

```ruby
test "raises" do
  expect { Thing.bar! }.to_raise(ArgumentError) do |error|
    expect(error.message) == "Foo bar"
  end
end
```

#### `to_receive`

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
