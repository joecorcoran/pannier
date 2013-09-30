require 'rack'
require 'pannier/app'
require 'pannier/asset_writer'
require 'pannier/version'

module Pannier
  def self.build(host_env = nil, &block)
    App.build(host_env, &block)
  end

  def self.build_from(path, host_env = nil)
    config = File.read(path)
    block = eval("proc { #{config} }", TOPLEVEL_BINDING, path, 0)
    App.build(host_env, &block)
  end

  def self.rackup!(ru, path = './Pannierfile')
    app = build_from(path, ENV['RACK_ENV'])
    app.process!
    ru.map(app.root) { run(app) }
    app
  end
end
