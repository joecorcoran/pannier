module Pannier
  class Manifest

    attr_reader :tree

    def initialize(app)
      @app, @tree = app, {}
    end

    def build!
      build_source! && build_result!
      self
    end

    def build_source!
      @app.packages.each do |package|
        @tree[package.name] ||= {}
        unless package.source_assets.empty?
          @tree[package.name][:source] = package.source_assets.map(&:path)
        end
      end
    end

    def build_result!
      @app.packages.each do |package|
        @tree[package.name] ||= {}
        unless package.result_assets.empty?
          @tree[package.name][:result] = package.result_assets.map(&:path)
        end
      end
    end

    def package_details(name = nil, state = nil)
      details = @tree
      details = @tree[name.to_sym] if name
      details = @tree[name.to_sym][state.to_sym] if state
      details
    end

  end
end
