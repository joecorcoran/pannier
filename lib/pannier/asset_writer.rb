require 'pannier/template'

module Pannier
  class AssetWriter

    attr_reader :app, :templates

    def initialize(app, input_env = 'development')
      @app, @input_env, @templates = app, input_env, {}
      add_template(:js, Template::Javascript.new)
      add_template(:css, Template::CSS.new)
    end

    def add_template(tmpl_name, tmpl)
      @templates[tmpl_name] = tmpl
    end

    def write(tmpl_name, package_name, attrs = {})
      tmpl = @templates[tmpl_name]
      pkg  = @app[package_name]
      to_write = pkg.assets.map do |asset|
        tmpl.call(pkg.server_path_for(asset), attrs)
      end
      to_write.join("\n")
    end

  end
end
