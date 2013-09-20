module Pannier
  class Report

    attr_reader :tree

    def initialize(app)
      @app, @tree = app, {}
    end

    def build!
      @app.packages.each do |package|
        @tree[package.name] ||= {}
        unless package.input_assets.empty?
          @tree[package.name][:input] = package.input_assets.map(&:path)
        end
        unless package.output_assets.empty?
          @tree[package.name][:output] = package.output_assets.map(&:path)
          @tree[package.name][:app] = package.output_assets.map do |asset|
            asset.serve_from(@app)
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
