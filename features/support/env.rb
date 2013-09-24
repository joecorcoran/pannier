# Make fixtures directory available
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'fixtures'))

require 'bundler/setup'
require 'aruba/cucumber'
require 'aruba/in_process'
require 'rack/test'

require 'pannier'
require 'pannier/cli'
require_relative './file_helper'

Aruba::InProcess.main_class = Pannier::CLI
Aruba.process = Aruba::InProcess

module TestApp
  def app
    @app
  end
end

World(Rack::Test::Methods, TestApp)
