require 'rack'

require 'pannier'
require 'pannier/mounted/app'
require 'pannier/mounted/asset'
require 'pannier/mounted/package'
require 'pannier/mounted/tags'

module Pannier
  def self.prime(path, env_name = 'development')
    app = load(path, env_name)
    if manifest_exists?(app, env_name)
      manifest = load_manifest(app, env_name)
      app.prime!(manifest)
    end
    app
  end

  def self.rackup(ru, path = './.assets.rb')
    app = prime(path, ENV['RACK_ENV'])
    ru.map(app.root) { run(app) }
    app
  end

  private

    def self.load_manifest(app, env_name)
      path = File.join(app.input_path, ".assets.#{env_name}.json")
      json = File.read(path)
      MultiJson.load(json, :symbolize_keys => true)
    end

    def self.manifest_exists?(app, env_name)
      path = File.join(app.input_path, ".assets.#{env_name}.json")
      File.exists?(path)
    end
end
