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
      outputs = assets_from(package_name).map do |asset|
        tmpl.call(asset.serve_from(@app), attrs)
      end
      outputs.join("\n")
    end

    private

      def assets_from(package_name)
        input_env = Regexp.new(@input_env)
        @app[package_name].send(
          @app.host_env =~ input_env ? :input_assets : :output_assets
        )
      end

  end
end
