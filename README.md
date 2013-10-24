# Tryit

Another approach to Rail's `Object#try`. This is the result of a StackOverflow discussion between [Sergey Gopkalo](https://github.com/sevenmaxis/) and [Michael Kohl](https://github.com/citizen428). The original repository can be found at [sevenmaxis/tryit](https://github.com/sevenmaxis/tryit).

Instead of

    obj1.try(:met1).try(:met2).try(:met3).to_s

you can do this

    obj1.tryit { met1.met2.met3.to_s }

or this (the preferred form):

    tryit { obj.met1.met2.met3.to_s }

You can customize which excpetions to catch:

    TryIt.exceptions << ZeroDivisionError
    tryit { 1/0 }  # will not raise exceptions

There's also the possibility to define your own exception handlers:

    TryIt.handler = lambda { |_| puts "message from tryit" }
    tryit { raise NoMethodError } # will print "message from tryit"

## Installation

Add this line to your application's Gemfile:

    gem 'tryit'

And then execute:

    $ bundle

Or install it yourself:

    $ gem install tryit

## Todo

* Find a way to make the exception list not global.

## License

Lincesend under the MIT license. See the provided LICENSE file for details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
