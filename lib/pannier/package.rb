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
      @source_path = path
    end

    def result(path)
      @result_path = path
    end

    def full_source_path
      @full_source_path ||= File.expand_path(File.join(*[@app.source_path, @source_path].compact))
    end

    def full_result_path
      @full_result_path ||= File.expand_path(File.join(*[@app.result_path, @result_path].compact))
    end

    def assets(*patterns)
      patterns.each do |pattern|
        paths = Dir[File.join(full_source_path, pattern)]
        new_assets = paths.map do |asset_source_path|
          asset_result_path = asset_source_path.gsub(full_source_path, full_result_path)
          Asset.new(asset_source_path, asset_result_path, self)
        end
        @asset_set.merge(new_assets)
      end
    end

    def process(&proc)
      @process_proc = proc
    end

    def concat(concat_name, concatenator_klass = Concatenator)
      @concatenator = concatenator_klass.new(full_result_path, concat_name)
    end

    def run!
      processed_assets = @asset_set
      if @process_proc
        processed_assets.each do |asset|
          asset.content = @process_proc.call(asset.content)
        end
      end
      if @concatenator
        @concatenator.concat!(processed_assets.map(&:content))        
      else
        processed_assets.each(&:write!)
      end
    end

  end
end
