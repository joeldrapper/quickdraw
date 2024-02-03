# Quickdraw

Quickdraw is currently in development. You should almost definitely not use it in a project until `1.0` is released.

> [!TIP]
> Your test files are executed in an anonymous class, so you can define methods and constants at the top level without worrying about collisions. If you’re testing something that references `Class.name`, you may have to define those classes as fixtures somewhere else.

## Getting Started

Add this line to your application's Gemfile:

```ruby
gem 'quickdraw'
```

And then execute:

```bash
bundle install
```

Now create a file called `config/quickdraw.rb`.

To run tests, execute:
```bash
bundle exec gd
```

## Usage

Quickdraw searches for files that end with `.test.rb`. You can put these anywhere. Some people like to put them under `/tests` or `/spec`. Others like to put them next to the code they're testing.

### `.test`
Use the `test` method to define a test. The description is optional — sometimes you don’t need it.

```ruby
test { assert true }
```

You can pass `skip: true` to skip the test. Skipped tests are still run; they pass if they fail and fail they pass.

```ruby
test(skip: true) { assert false }
```

### `.describe`
You can optionally wrap tests in any number of `describe` blocks, which can take a description as a string or module/class.

```ruby
describe Thing do
  # your Thing tests here
end
```

### `#assert`
`assert` takes a value and passes if it’s truthy.

```ruby
test "something" do
  assert true
end
```

You can pass a custom failure message as a block. Using blocks for the failure messages means we don’t waste time constructing them unless the test fails. You don’t need to worry about expensive failure messages slowing down your tests.

```ruby
test "something" do
	assert(false) { "This is a custom failure message" }
end
```

### `#refute`
`refute` is just like `assert`, but it passes if the value is falsy.

```ruby
test "something" do
  refute false
end
```

### `expect` matchers
`expect` takes either a value or a block and returns an expectation object, which you can call matchers on.

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
