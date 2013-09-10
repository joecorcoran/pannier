# Make fixtures directory available
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'fixtures'))

require 'bundler/setup'
require 'pannier'
require 'rack/test'
require 'json_expressions'
require 'json_expressions/rspec/matchers'
require_relative './file_helper'

module TestApp
  def app
    @app
  end
end

World(Rack::Test::Methods, JsonExpressions::RSpec::Matchers, TestApp)
