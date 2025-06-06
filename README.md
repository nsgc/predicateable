# Predicateable

**Predicateable** is a Ruby mixin that dynamically defines predicate methods (like `admin?`, `young?`) based on the return value of a method. It's ideal for cleanly querying symbolic states without writing repetitive predicate methods.

## Features

- Defines `?` predicate methods dynamically.
- Supports prefixing (e.g. `account_type_admin?`).
- `strict:` option ensures only symbols are matched.
- Works seamlessly with `respond_to?`.
- Pure Ruby, no dependencies.

## Installation

Add this line to your Gemfile:

```ruby
gem "predicateable"
````

And run:

```sh
bundle install
```

Or install it directly:

```sh
gem install predicateable
```

## Usage

### Basic Example

```ruby
class User
  include Predicateable

  attr_reader :age, :account_type

  predicate :age_group, [:young, :middle, :old]
  predicate :account_type, [:guest, :member, :admin], prefix: true

  def initialize(age:, account_type:)
    @age = age
    @account_type = account_type
  end

  def age_group
    case age
    when 0...30 then :young
    when 30...60 then :middle
    else :old
    end
  end
end

user = User.new(age: 45, account_type: :admin)

user.middle?                # => true
user.age_group              # => :middle
user.account_type_admin?    # => true
user.account_type_guest?    # => false
```

### Strict Mode

If you want predicate checks to pass only when the method returns a **Symbol**, enable `strict: true`:

```ruby
class User
  include Predicateable

  attr_reader :role

  predicate :role, [:editor, :viewer], strict: true

  def initialize(role:)
    @role = role
  end
end

User.new(role: :editor).editor?  # => true
User.new(role: "editor").editor? # => false (strict mode)
```

## Behavior Summary

| Feature         | Description                                    |
| --------------- | ---------------------------------------------- |
| `prefix:`       | Adds method name prefix (e.g. `account_type_`) |
| `strict:`       | Only matches `Symbol` values                   |
| `respond_to?`   | Works with predicate methods                   |
| `NoMethodError` | Raised when calling undefined predicates       |

## Testing

This gem uses [Minitest](https://github.com/minitest/minitest). To run tests:

```sh
bundle exec rake test
```

## Contributing

Bug reports and pull requests are welcome! If you have ideas for improvement or questions, feel free to open an issue.

## License

This project is licensed under the MIT License. See the [LICENSE.txt](LICENSE.txt) file for details.
