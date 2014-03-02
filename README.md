# Pannier

[![Build Status](https://travis-ci.org/joecorcoran/pannier.png?branch=master)](https://travis-ci.org/joecorcoran/pannier) [![Code Climate](https://codeclimate.com/github/joecorcoran/pannier.png)](https://codeclimate.com/github/joecorcoran/pannier)

Pannier is a general-purpose Ruby asset processing tool. Its goal is to
work the same way in any Rack environment. No Rails glue, no mandatory
JavaScript or CSS libraries, preprocessors or gems.

The configuration DSL was inspired by &#8212; but is ultimately quite
different from &#8212; [rake-pipeline][rp]. The config describes a Rack
application that handles asset processing (modification of file contents
and file names, file concatenation). No decisions about
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
It's a fine idea, but as soon as you need to ditch one of more of those
conventions you'll be frustrated.

I have found the
[principle of least astonishment][pola] to be far more valuable than
an *automagic* beginners' experience in the long run. This is especially
true where asset processing in Rails is concerned. I want explicit control
over my assets and I don't mind spending a small amount of time on
configuration.

## Getting started

Create a config file in the root of your project named `.assets.rb`. The
example below will simply take all of your stylesheets from one directory
and concatenate them in another.


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

Your stylesheets have now been quuxified and concatenated into
`public/main.min.css`.

Modifiers are just Ruby *callables*; blocks, procs, lambdas, objects that
respond to `call`. They are executed in order of specification. Here's a
typical use case.

```ruby
require 'digest'
# ...

package :styles do
  # ...

  modify { |content, _|  [foo(content), _] }
  modify { |content, _|  [bar(content), _] }
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

## License

[MIT][license].

[sprockets]: https://github.com/sstephenson/sprockets
[pola]: http://en.wikipedia.org/wiki/Principle_of_least_astonishment
[rp]: https://github.com/livingsocial/rake-pipeline
[relish]: https://www.relishapp.com/joecorcoran/pannier/docs
[todo]: https://github.com/joecorcoran/pannier/wiki/Todo
[license]: https://github.com/joecorcoran/pannier/blob/master/LICENSE.txt
