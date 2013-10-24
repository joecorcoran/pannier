# Pannier

[![Build Status](https://travis-ci.org/joecorcoran/pannier.png?branch=master)](https://travis-ci.org/joecorcoran/pannier) [![Code Climate](https://codeclimate.com/github/joecorcoran/pannier.png)](https://codeclimate.com/github/joecorcoran/pannier)

*Not yet released. Master branch may be unstable.*

Pannier is a general-purpose Ruby asset processing tool. Its goal is to
work the same way in any Rack environment. No Rails glue, no mandatory
JavaScript or CSS libraries.

## Why?

The Rails asset pipeline essentially consists of [Sprockets][sprockets]
and a bunch of inscrutable Rails coupling. You generate a new Rails app
and everything is setup for you.

We call this "convention over configuration". It's a fine idea, but as
soon as your app develops beyond the lowest common denominator
you'll need to ditch at least some of those conventions. Deviation from
convention is unencouraged and ultimately quite a lonely and frustrating
thing to do.

I have found the
[principle of least astonishment][pola] to be far more valuable than
an *automagic* beginners' experience in the long run. This is especially
true where asset processing in Rails is concerned. I want explicit control
over my assets and I don't mind spending a small amount of time on
configuration.

## What does it do?

The configuration DSL was inspired by &#8212; but is ultimately quite
different from &#8212; [rake-pipeline][rp]. The config describes a Rack
application that handles asset processing (modification of file contents
and file names, file concatenation). No decisions about
uglifiers/optimisers/preprocessors have been made; that part is up to you.
The interface to plug one of these libraries into Pannier is very simple
and inspired by Rack.

In some cases the above is all you'll need, but the application
can also be mounted (mapped to a path) within another Rack application, so
it can serve your assets too. In that case, there are helper methods for
including your assets in the view layer. Adding your own view helpers is
easy too.

It's a work in progress and full documentation is still outstanding.

To understand more, you can
[browse the current features][relish] and the
[todo list][todo].

## Contributing

Yes, please contribute! Fork this repo, then send a pull request with a
note that clearly explains your changes. If you're unsure or you're
asking for a big change, just open an issue and we can chat about it first.

## License

[MIT][license].

[sprockets]: https://github.com/sstephenson/sprockets
[pola]: http://en.wikipedia.org/wiki/Principle_of_least_astonishment
[rp]: https://github.com/livingsocial/rake-pipeline
[relish]: https://www.relishapp.com/joecorcoran/pannier/docs
[todo]: https://github.com/joecorcoran/pannier/wiki/Todo
[license]: https://github.com/joecorcoran/pannier/blob/master/LICENSE.txt
