module Pannier
  class Manifest

    attr_reader :tree

    def initialize(app)
      @app, @tree = app, {}
    end

    def build!
      @app.packages.each do |package|
        @tree[package.name] ||= {}
        unless package.source_assets.empty?
          @tree[package.name][:source] = package.source_assets.map(&:path)
        end
        unless package.result_assets.empty?
          @tree[package.name][:result] = package.result_assets.map(&:path)
          @tree[package.name][:app] = package.result_assets.map do |asset|
            asset.serve_from(@app.root, @app.result_path)
          end
        end
      end
      self
    end

    def package_details(name = nil, state = nil)
      details = @tree
      details = @tree[name.to_sym] if name
      details = @tree[name.to_sym][state.to_sym] if state
      details
    end

  end
end
