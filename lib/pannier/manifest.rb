module Pannier
  class Manifest

    attr_reader :tree

    def initialize(app)
      @app, @tree = app, {}
    end

    def build_source!
      @app.packages.each do |package|
        @tree[package.name] ||= {}
        @tree[package.name][:source] = package.source_assets.map(&:path)
      end
    end

    def build_result!
      @app.packages.each do |package|
        @tree[package.name] ||= {}
        @tree[package.name][:result] = package.result_assets.map(&:path)
      end
    end

    def package_details(name, state = nil)
      name = name.to_sym
      details = @tree[name]
      details = @tree[name][state.to_sym] if state
      details
    end

  end
end
