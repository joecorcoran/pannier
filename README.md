# Pannier

[![Build Status](https://travis-ci.org/joecorcoran/pannier.png?branch=master)](https://travis-ci.org/joecorcoran/pannier) [![Code Climate](https://codeclimate.com/github/joecorcoran/pannier.png)](https://codeclimate.com/github/joecorcoran/pannier)

Pannier is a general-purpose Ruby asset processing tool. Its goal is to
work the same way in any Rack environment. No Rails glue, no mandatory
JavaScript or CSS libraries, preprocessors or gems.

A small configuration DSL describes asset processing: modification of file
contents and file names, file concatenation. No decisions about
uglifiers/optimisers/preprocessors have been made; that part is up to you.

The interface for plugging any asset processing library into Pannier is very
basic and inspired by Rack. The lack of a plugin ecosystem that binds you to any
particular preprocessor is considered a feature.

Pannier can also act as a Rack application that
can be mounted (mapped to a path) within another Rack application, so
it can serve your assets too. In that case, there are helper methods for
including your assets in the view layer. Adding your own view helpers is
easy too.

## Why?

The Rails asset pipeline essentially consists of [Sprockets][sprockets]
and a bunch of inscrutable Rails coupling. You generate a new Rails app
and everything is setup for you. We call this "convention over configuration".
It's fine, but as soon as you need to ditch one or more of those
conventions you'll be frustrated.

I have found the
[principle of least astonishment][pola] to be far more valuable than
an *automagic* beginners' experience in the long run. This is especially
true where asset processing in Rails is concerned. I want explicit control
over my assets and I don't mind spending a small amount of time on
configuration.

## Getting started

Create a config file in the root of your project named `.assets.rb`.

The example below would take all of your stylesheets from one directory,
modify them and then concatenate them into a single file in another
directory.


```ruby
input  'assets'                    # Where your unprocessed assets live.
output 'public'                    # Where your processed assets will live.

package :styles do
  input  'stylesheets'             # Relative to `assets`.
  assets '**/*.css'                # Glob, relative to `assets/stylesheets`.

  modify do |content, basename|    # Do something to the file content here.
    [quuxify(content), basename]   # Return an array of content and basename.
  end                              # This block is called once for each file.

  concat 'main.min.css'            # Concat into `public`.
end
```

```bash
$ pannier process
```

Your stylesheets from `assets/stylesheets` have now all been quuxified and
concatenated into `public/main.min.css`.

## Modifying assets

Modifiers are just Ruby *callables*; blocks, procs, lambdas, objects that
respond to `call`. They are executed in order of specification. Here's a
typical use case: assets are run through a couple of modifiers, then
concatenated into one file, then finally that single file has a hash of
its contents appended to its name.

```ruby
require 'foo'
require 'bar'
require 'digest'
# ...

package :styles do
  # ...

  modify { |content, basename|  [foo(content), basename] }
  modify { |content, basename|  [bar(content), basename] }
  concat 'main'
  modify do |content, basename|
    [content, "#{basename}-#{Digest::MD5.hexdigest(content)}.min.css"]
  end
end
```

To understand further, you can [browse the current features on relish][relish].

## Contributing

Yes, please contribute! Fork this repo, then send a pull request with a
note that clearly explains your changes. If you're unsure or you're
asking for a big change, just open an issue and we can chat about it first.

## Credits

Built by [Joe Corcoran][joe]. Thanks to the authors of [rake-pipeline][rp],
a project which tried to address a similar problem.

## License

[MIT][license].

[sprockets]: https://github.com/sstephenson/sprockets
[pola]: http://en.wikipedia.org/wiki/Principle_of_least_astonishment
[joe]: https://corcoran.io
[rp]: https://github.com/livingsocial/rake-pipeline
[relish]: https://www.relishapp.com/joecorcoran/pannier/docs
[todo]: https://github.com/joecorcoran/pannier/wiki/Todo
[license]: https://github.com/joecorcoran/pannier/blob/master/LICENSE.txt
