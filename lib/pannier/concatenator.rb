module Pannier
  class Concatenator < Struct.new(:path, :name)

    def concat!(assets)
      FileUtils.mkdir_p(path)
      File.open(File.join(path, name), 'w+') do |file|
        file << reduced_assets(assets)
      end
    end

    def reduced_assets(assets)
      @reduced_assets ||= assets.reduce("") do |reduced, asset|
        reduced << asset.piped_content
      end
    end

  end
end
