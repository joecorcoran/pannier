module Pannier
  class Manifest

    def initialize(app)
      @app, @manifest = app, {}
    end

    def build!
      @app.packages.each do |package|
        @manifest[package.name] = {}
        @manifest[package.name][:source] = package.source_assets.map(&:path)
        unless package.result_assets.empty?
          @manifest[package.name][:result] = package.result_assets.map(&:path)
        end
      end
    end

    def to_json
      MultiJson.dump(@manifest)
    end

  end
end
