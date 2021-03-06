require 'pannier/app'

module Pannier
  class App

    attr_reader :mount_path

    def set_mount_path(path)
      @mount_path = path
    end

    def prime!(manifest)
      manifest.each do |name, paths|
        if (pkg = self[name])
          assets = pkg.build_assets_from_paths(paths)
          pkg.add_output_assets(assets)
        end
      end
    end

    def handler_map
      @packages.reduce({}) do |hash, pkg|
        hash[pkg.handler_path] ||= Rack::Cascade.new([])
        hash[pkg.handler_path].add(pkg.handler)
        hash
      end
    end

    def handler
      Rack::URLMap.new(handler_map)
    end

    def call(env)
      handler.call(env)
    end

    dsl do

      def mount(path)
        set_mount_path(path)
      end

    end

  end
end
