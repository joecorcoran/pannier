module Pannier
  class AssetWriter

    def initialize(app)
      @app, @templates, @env = app, {}, {}
      add_template(:js, Template::Javascript.new)
      add_template(:css, Template::CSS.new)
    end

    def add_template(tmpl_name, tmpl)
      @templates[tmpl_name] = tmpl
    end

    def set_env(env)
      @env = env
    end

    def write(tmpl_name, package_name, attrs = {})
      tmpl = @templates[tmpl_name]
      results  = @app[package_name].result_assets.map do |asset|
        path = asset.env_path(@env, @app.result_path)
        tmpl.call(path, attrs)
      end
      results.join("\n")
    end

  end
end
