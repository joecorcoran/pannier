require 'set'

module Pannier
  class Package

    attr_reader :name, :app, :asset_set, :source_path, :result_path

    def initialize(name, app, &block)
      @name, @app, @asset_set = name, app, Set.new
      self.instance_eval(&block) if block_given?
      self
    end

    def source(path)
      @source_path = File.expand_path(File.join(*[@app.source_path, path].compact))
    end

    def result(path)
      @result_path = File.expand_path(File.join(*[@app.result_path, path].compact))
    end

    def assets(*patterns)
      patterns.each do |pattern|
        paths = Dir[File.join(@source_path, pattern)]
        new_assets = paths.map do |asset_source_path|
          asset_result_path = asset_source_path.gsub(@source_path, @result_path)
          Asset.new(asset_source_path, asset_result_path, self)
        end
        @asset_set.merge(new_assets)
      end
    end

    def process(&proc)
      @process_proc = proc
    end

    def process!
      processed_assets = @asset_set.to_a
      processed_assets = @process_proc.call(processed_assets) if @process_proc
      processed_assets.each do |asset|
        asset.write!
      end
    end

  end
end
