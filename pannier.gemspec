# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pannier/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'pannier'
  s.version     = Pannier::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Joe Corcoran']
  s.email       = ['joecorcoran@gmail.com']
  s.homepage    = 'http://github.com/joecorcoran/pannier'
  s.summary     = 'Organize your assets'
  s.description = 'A simple, portable Ruby web application asset manager'

  s.add_dependency             'rack',         '~> 1.5.2'

  s.add_development_dependency 'rake',         '~> 10.1.0'
  s.add_development_dependency 'rspec',        '~> 2.14.1'
  s.add_development_dependency 'mocha',        '~> 0.14.0'
  s.add_development_dependency 'cucumber',     '~> 1.3.6'

  s.files        = Dir['{lib}/**/*.rb'] + ['README.md', 'LICENSE.txt']
  s.require_path = 'lib'
end
