require 'multi_json'
require 'rack'

require 'pannier/app'
require 'pannier/asset_writer'
require 'pannier/version'

module Pannier
  def self.build(env_name = 'development', &block)
    App.build(env_name, &block)
  end

  def self.rackup!(ru, path = './.assets.rb')
    app = load(path, ENV['RACK_ENV'])
    ru.map(app.root) { run(app) }
    app
  end

  private

    def self.build_from(path, env_name)
      config = File.read(path)
      block = eval("proc { #{config} }", TOPLEVEL_BINDING, path, 0)
      App.build(env_name, &block)
    end

    def self.load(path, env_name = 'development')
      app = build_from(path, env_name)
      if manifest_exists?(app, env_name)
        manifest = load_manifest(app, env_name)
        app.prime!(manifest)
      end
      app
    end

    def self.load_manifest(app, env_name)
      path = File.join(app.output_path, ".assets.#{env_name}.json")
      json = File.read(path)
      MultiJson.load(json, :symbolize_keys => true)
    end

    def self.manifest_exists?(app, env_name)
      path = File.join(app.output_path, ".assets.#{env_name}.json")
      File.exists?(path)
    end
end
