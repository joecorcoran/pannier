# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pannier/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'pannier'
  s.version     = Pannier::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Joe Corcoran']
  s.email       = ['joecorcoran@gmail.com']
  s.homepage    = 'http://github.com/joecorcoran/pannier'
  s.summary     = 'A simple, portable asset processing tool for Ruby web apps'
  s.license     = 'MIT'
  s.description = <<-txt
Pannier is a Ruby tool for the processing of web assets like CSS
and JavaScript files. It can be used as a standalone asset organizer or mounted
within any Rack-compatible application.
txt

  s.add_dependency             'rack',             '~> 1.5'
  s.add_dependency             'multi_json',       '~> 1.7'
  s.add_dependency             'slop',             '~> 3.4'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec',            '~> 3'
  s.add_development_dependency 'mocha',            '~> 1.0'
  s.add_development_dependency 'cucumber',         '~> 2'
  s.add_development_dependency 'aruba',            '~> 1.0.0.pre.alpha2'
  s.add_development_dependency 'rack-test',        '~> 0.6',  '>= 0.6.2'

  s.files        = Dir['lib/**/*.rb'] + ['README.md', 'LICENSE.txt']
  s.require_path = 'lib'
  s.executables << 'pannier'
end
