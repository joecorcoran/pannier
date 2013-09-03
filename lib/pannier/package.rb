require 'set'

module Pannier
  class Package

    attr_reader :name, :app, :source_assets, :result_assets, :source_path,
                :result_path

    def initialize(name, app, &block)
      @name, @app = name, app
      @source_assets, @result_assets = Set.new, Set.new
      @middlewares = []
      self.instance_eval(&block) if block_given?
      self
    end

    def source(path)
      @source_path = path
    end

    def result(path)
      @result_path = path
    end

    def behaviors(*names)
      names.each do |name|
        behavior = @app.behaviors[name]
        raise MissingBehavior.new(name) if behavior.nil?
        self.instance_eval(&behavior)
      end
    end

    def assets(*patterns)
      patterns.each do |pattern|
        paths = Dir[File.join(full_source_path, pattern)]
        assets = paths.map do |path|
          pathname = Pathname.new(path)
          Asset.new(pathname.basename, pathname.dirname, self)
        end
        @source_assets.merge(assets)
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

    def use(middleware, *args, &block)
      @middlewares << proc { |app| middleware.new(app, *args, &block) }
    end

    def full_source_path
      File.expand_path(File.join(*[@app.source_path, @source_path].compact))
    end

    def full_result_path
      File.expand_path(File.join(*[@app.result_path, @result_path].compact))
    end

    def handler
      handler = FileHandler.new(@result_assets.map(&:path), full_result_path)
      return handler if @middlewares.empty?
      @middlewares.reverse.reduce(handler) { |app, proc| proc.call(app) }
    end

    def handler_path
      path = @result_path.nil? ? '/' : @result_path
      path.insert(0, '/') unless path[0] == '/'
      path
    end

    def process!
      @processors && @processors.each do |processor|
        @source_assets.each do |asset|
          asset.content = processor.call(asset.content)
        end
      end
      concat! || copy!
    end

    def concat!
      return unless @concat_name
      asset = Asset.new(@concat_name, full_result_path, self)
      asset.content = @concatenator.call(@source_assets.sort.map(&:content))
      @result_assets.add(asset)
      write!
    end

    def copy!
      assets = @source_assets.map do |asset|
        asset.copy_to(full_result_path)
      end
      @result_assets.merge(assets)
      write!
    end

    def write!
      @result_assets.each(&:write!)
    end

  end
end
