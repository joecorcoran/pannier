require 'pannier/template'

module Pannier
  class AssetWriter

    def initialize(app)
      @app, @templates = app, {}
      add_template(:js, Template::Javascript.new)
      add_template(:css, Template::CSS.new)
    end

    def add_template(tmpl_name, tmpl)
      @templates[tmpl_name] = tmpl
    end

    def write(tmpl_name, package_name, attrs = {})
      tmpl = @templates[tmpl_name]
      outputs  = @app[package_name].output_assets.map do |asset|
        path = asset.serve_from(@app)
        tmpl.call(path, attrs)
      end
      outputs.join("\n")
    end

  end
end
