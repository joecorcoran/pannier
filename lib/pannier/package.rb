require 'set'
require 'pathname'
require 'pannier/asset'
require 'pannier/concatenator'
require 'pannier/dsl'
require 'pannier/errors'
require 'pannier/file_handler'

module Pannier
  class Package
    extend DSL

    attr_reader :name, :app, :source_assets, :result_assets, :source_path,
                :result_path, :middlewares, :processors

    def initialize(name, app)
      @name, @app = name, app
      @source_assets, @result_assets = SortedSet.new, SortedSet.new
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

    def add_modifiers(*modifiers)
      @processors += modifiers.map { |m| [:modify!, m] }
    end

    def add_concatenator(concat_name, concatenator = Concatenator.new)
      @processors << [:concat!, concat_name, concatenator]
    end

    def add_middleware(middleware, *args, &block)
      @middlewares << proc { |app| middleware.new(app, *args, &block) }
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
      copy!
      !@processors.empty? && @processors.each do |instructions|
        send(*instructions)
      end
      write_files!
    end

    def modify!(modifier)
      @result_assets.each do |asset|
        asset.modify!(modifier)
      end
    end

    def concat!(concat_name, concatenator)
      asset = Asset.new(concat_name, full_result_path, self)
      asset.content = concatenator.call(@result_assets.map(&:content))
      @result_assets.replace([asset])
    end

    def copy!
      assets = @source_assets.map do |asset|
        asset.copy_to(full_result_path)
      end
      @result_assets.replace(assets)
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

      def modify(*modifiers, &block)
        modifiers << block if block_given?
        add_modifiers(*modifiers)
      end

      def concat(*args)
        add_concatenator(*args)
      end

      def use(*args, &block)
        add_middleware(*args, &block) 
      end

    end
  end
end
