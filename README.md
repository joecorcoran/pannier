# Pannier

[![Build Status](https://travis-ci.org/joecorcoran/pannier.png?branch=master)](https://travis-ci.org/joecorcoran/pannier)

An asset management framework that makes no assumptions. A Rack application that
packages and processes assets, includes them in your application and also
optionally serves them too.

## Why?

The Rails asset pipeline has many tentacles. It sacrifices adaptability for the
sake of convention. This couples your Rails application to many third-party
libraries and increases the complexity of the out-of-the-box experience
considerably.

I want a general purpose Ruby asset managment option that works in any Ruby
environment and approaches the problem from the opposite side. The main tenets
of this project are extensibility and the
[principle of least astonishment][pola].

## What does it do?

It's a work in progress. To understand more, you can
[browse the current documentation][relish] and the
[list of upcoming features/considerations][todo].

[pola]: http://en.wikipedia.org/wiki/Principle_of_least_astonishment
[relish]: https://www.relishapp.com/joecorcoran/pannier/docs
[todo]: https://github.com/joecorcoran/pannier/wiki/Todo
