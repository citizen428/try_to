# try_to

[![Build Status](https://travis-ci.org/citizen428/try_to.svg)](https://travis-ci.org/citizen428/methodfinder)
[![Gem Version](https://img.shields.io/gem/v/try_to.svg)](https://rubygems.org/gems/methodfinder)

This project started with a StackOverflow discussion between [Sergey Gopkalo](https://github.com/sevenmaxis/) and [Michael Kohl](https://github.com/citizen428),
which eventually lead to a prototype at [sevenmaxis/tryit](https://github.com/sevenmaxis/tryit).
`try_to` is an improved version based on the experience gained from that project,
but allows for much more sophisticated error handling.

## Usage

Instead of using Rails' `Object#try` like this,

```ruby
obj.try(:met1).try(:met2).try(:met3).to_s
```

you can do this:

```ruby
try_to { obj.met1.met2.met3.to_s }
```

### Exceptions

#### Adding exceptions

It's possible to customize which exceptions to handle with `add_exception`:

```ruby
TryTo.add_exception(ZeroDivisionError)
#=> [NoMethodError, ZeroDivisionError]
try_to { 1/0 } # will not raise an exception
```

#### Removing exceptions

To remove an exception, use `remove_exception!`:

```ruby
TryTo.exceptions
#=> [NoMethodError, ZeroDivisionError]
TryTo.remove_exception!(ZeroDivisionError)
#=> [NoMethodError]
```

#### Resetting exceptions

You can also use `reset_exceptions!` to go back to only handle `NoMethodError`s.

```ruby
TryTo.exceptions
#=> [NoMethodError, RuntimeError, ZeroDivisionError]
TryTo.reset_exceptions!
#=> [NoMethodError]
```

### Handlers

The default error handling strategy is to just return `nil`, but there are various
ways in which you can customize this behavior. All handlers can either be simple
values or an object responding to `#call`, which should take one argument, the
exception object.

#### Specifying a handler inline:

```ruby
try_to(-> e { puts e.class }) { 1.foo }
# prints "NoMethodError"
# or provide a simple value:
try_to(42) { 1.foo }
#=> 42
```

#### Registering handlers for exception classes:

```ruby
TryTo.handlers
#=> {}
TryTo.add_handler(ZeroDivisionError, -> _ { puts "Ouch" })
try_to { 1/0 }
# prints "Ouch"
TryTo.add_handler(NoMethodError, -> _ { 23 })
try_to { 1.foo }
#=> 23
# or simply
TryTo.add_handler(NoMethodError, 42)
try_to { 1.foo } #=> 42
```

#### Removing handlers:

    TryTo.handlers
    #=> {ZeroDivisionError=>#<Proc:0x0000000108921d60@(irb):1 (lambda)>}
    TryTo.remove_handler!(ZeroDivisionError)
    #=> {}

#### Default handler

This will be called for all the exceptions listed in `TryTo.exceptions`.

```ruby
TryTo.default_handler = 42
try_to { 1.foo } #=> 42
# or
TryTo.default_handler = -> _e { puts "Something went wrong!" }
try_to { 1.foo }
# Outputs: Something went wrong!
```

#### Example

Here's a complete example in the form of an IRB transcript:

```ruby
# default behavior
try_to #=> nil
try_to {} #=> nil
Foo = Class.new
try_to { Foo.new.foo } #=> nil (instead of NoMethodError)

# this will raise an exception
try_to { 1 / 0 }
ZeroDivisionError: divided by 0
# let's fix that
TryTo.add_exception(ZeroDivisionError) #=> [NoMethodError, ZeroDivisionError]
try_to { 1 / 0 } #=> nil

# change the default handler
TryTo.default_handler = -> e { puts e.class }
try_to { 1 / 0 } # prints "ZeroDivisionError"
try_to { Foo.new.foo } # prints "NoMethodError"

# new behavior for ZeroDivisionError
TryTo.add_handler(ZeroDivisionError, -> _ { puts "You shouldn't divide by 0!"})
try_to { 1 / 0 } # prints: "You shouldn't divide by 0!"
try_to { Foo.new.foo} # still prints "NoMethodError"

# change handler at call site
try_to(-> _ {puts "Ouch!"}) { Foo.new.foo } # prints "Ouch!"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'try_to'
```

And then execute:

```shell
$ bundle
```

Or install it yourself:

```shell
$ gem install try_to
```

## Authors

[Michael Kohl](https://github.com/citizen428). There's some leftover code (primarily in the specs) from [sevenmaxis/tryit](https://github.com/sevenmaxis/tryit) by [Sergey Gopkalo](https://github.com/sevenmaxis/).

## License

Licensed under the MIT license. See the provided LICENSE file for details.

## Contributing

1.  Fork it
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Added some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create new Pull Request
