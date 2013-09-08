module Pannier
  class AssetWriter

    def initialize(app)
      @app, @templates = app, {}
      add_template(:js, Templates::Javascript.new)
      add_template(:css, Templates::CSS.new)
    end

    def add_template(tmpl_name, tmpl)
      @templates[tmpl_name] = tmpl
    end

    def write(tmpl_name, package_name)
      tmpl = @templates[tmpl_name]
      paths  = @app[package_name].result_assets.map do |asset|
        asset.absolute_path_from(@app.result_path)
      end
      paths.map { |path| tmpl.call(path) }.join("\n")
    end

  end

  module Templates
    class Javascript
      def call(path)
        "<script type=\"text/javascript\" src=\"#{path}\"></script>"
      end
    end

    class CSS
      def call(path)
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"#{path}\" />"
      end
    end
  end
end
