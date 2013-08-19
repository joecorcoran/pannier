require 'set'

module Pannier
  class Package

    attr_reader :name, :app, :asset_paths, :source_path

    def initialize(name, app, &block)
      @name, @app, @asset_paths = name, app, Set.new
      self.instance_eval(&block) if block_given?
      self
    end

    def source(path)
      @source_path = path
    end

    def full_path
      @full_path ||= File.join(*[@app.source_path, @source_path].compact)
    end

    def assets(*patterns)
      patterns.each do |pattern|
        paths = Dir[File.join(full_path, pattern)]
        @asset_paths.merge(paths)
      end
    end

  end
end
