module Pannier
  class Report

    attr_reader :tree

    def initialize(app, base_url)
      @app, @base_url, @tree = app, base_url, {}
      build!
    end

    def build!
      @app.packages.each do |package|
        @tree[package.name] ||= []
        next if package.output_assets.empty?
        @tree[package.name] = package.output_assets.map do |asset|
          @base_url + asset.serve_from(@app)
        end
      end
      self
    end

    def lookup(package_name)
      return @tree if package_name.nil?
      @tree[package_name.to_sym]
    end

  end
end
