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

    def process(*processors, &block)
      @processors = processors
      @processors << block if block_given?
    end

    def concat(concat_name, concatenator = Concatenator.new)
      @concat_name  = concat_name
      @concatenator = concatenator
    end

    def run!
      process! 
      concat! || copy!
    end

    def process!
      return unless @processors
      @processors.each do |processor|
        @asset_set.each do |asset|
          asset.content = processor.call(asset.content)
        end
      end
    end

    def concat!
      return unless @concat_name
      FileUtils.mkdir_p(full_result_path)
      File.open(File.join(full_result_path, @concat_name), 'w+') do |file|
        file << @concatenator.call(@asset_set.sort.map(&:content))
      end
    end

    def copy!
      @asset_set.each(&:write_result!)
    end

  end
end
