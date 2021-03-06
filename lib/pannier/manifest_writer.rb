require 'fileutils'
require 'multi_json'

require 'pannier/report'

module Pannier
  class ManifestWriter

    def initialize(app, env)
      @app, @env = app, env
      @report = Report.new(@app)
    end

    def basename
      ".assets.#{@env.name}.json"
    end

    def content
      @report.build!
      MultiJson.dump(@report.tree)
    end

    def clobber!(dir_path)
      path = File.join(*[dir_path, basename].compact)
      FileUtils.rm_f(path)
    end

    def write!(dir_path)
      @report.build!
      FileUtils.mkdir_p(dir_path)
      File.open(File.join(dir_path, basename), 'w+') do |f|
        f << content
      end
    end

  end
end
