require 'multi_json'
require 'rack'
require 'pannier/app'
require 'pannier/asset_writer'
require 'pannier/version'

module Pannier
  def self.build(env_name = 'development', &block)
    App.build(env_name, &block)
  end

  def self.build_from(path, env_name)
    config = File.read(path)
    block = eval("proc { #{config} }", TOPLEVEL_BINDING, path, 0)
    App.build(env_name, &block)
  end

  def self.rackup!(ru, path = './.assets.rb')
    app = build_from(path, ENV['RACK_ENV'])
    if manifest_exists?(app)
      manifest = load_manifest(app)
      app.prime!(manifest)
    end
    ru.map(app.root) { run(app) }
    app
  end

  private

    def self.load_manifest(app)
      path = File.join(app.output_path, ".assets.#{ENV['RACK_ENV']}.json")
      json = File.read(path)
      MultiJson.load(json, :symbolize_keys => true)
    end

    def self.manifest_exists?(app)
      File.exists?(File.join(app.output_path, ".assets.#{ENV['RACK_ENV']}.json"))
    end
end
