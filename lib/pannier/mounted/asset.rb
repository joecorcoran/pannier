require 'pannier/asset'

module Pannier
  class Asset

    def serve_from(app)
      asset_path, app_output_path = Pathname.new(path), Pathname.new(app.output_path)
      relative_path = asset_path.relative_path_from(app_output_path)
      File.join(app.root, relative_path.to_s)
    end

  end
end
