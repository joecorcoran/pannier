require 'set'

module Pannier
  class Package
    extend DSL

    attr_reader :name, :app, :source_assets, :result_assets, :source_path,
                :result_path, :middlewares, :processors

    def initialize(name, app)
      @name, @app = name, app
      @source_assets, @result_assets = Set.new, Set.new
      @middlewares, @processors = [], []
    end

    def set_source(path)
      @source_path = path
    end

    def set_result(path)
      @result_path = path
    end

    def full_source_path
      File.expand_path(File.join(*[@app.source_path, @source_path].compact))
    end

    def full_result_path
      File.expand_path(File.join(*[@app.result_path, @result_path].compact))
    end

    def add_assets(*paths)
      assets = paths.map do |path|
        pathname = Pathname.new(path)
        Asset.new(pathname.basename, pathname.dirname, self)
      end
      @source_assets.merge(assets)
    end

    def add_processors(*processors)
      @processors += processors
    end

    def add_middleware(middleware, *args, &block)
      @middlewares << proc { |app| middleware.new(app, *args, &block) }
    end

    def set_concatenator(concat_name, concatenator = Concatenator.new)
      @concat_name  = concat_name
      @concatenator = concatenator
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
          asset.process!(processor)
        end
      end
      concat! || copy!
    end

    def concat!
      return unless @concat_name
      asset = Asset.new(@concat_name, full_result_path, self)
      asset.content = @concatenator.call(@source_assets.sort.map(&:content))
      @result_assets.add(asset)
      write_files!
    end

    def copy!
      assets = @source_assets.map do |asset|
        asset.copy_to(full_result_path)
      end
      @result_assets.merge(assets)
      write_files!
    end

    def write_files!
      @result_assets.each(&:write_file!)
    end

    dsl do

      def source(path)
        set_source(path)
      end

      def result(path)
        set_result(path)
      end

      def behave(*names)
        names.each do |name|
          behavior = self.app.behaviors[name]
          raise MissingBehavior.new(name) if behavior.nil?
          self.instance_eval(&behavior)
        end
      end

      def assets(*patterns)
        patterns.each do |pattern|
          paths = Dir[File.join(full_source_path, pattern)]
          add_assets(*paths)
        end
      end

      def process(*processors, &block)
        processors << block if block_given?
        add_processors(*processors)
      end

      def concat(*args)
        set_concatenator(*args)
      end

      def use(*args, &block)
        add_middleware(*args, &block) 
      end

    end
  end
end
