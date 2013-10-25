require 'delegate'
require 'set'

require 'pathname'
require 'pannier/asset'
require 'pannier/concatenator'
require 'pannier/dsl'
require 'pannier/errors'
require 'pannier/file_handler'
require 'pannier/rotator'

module Pannier
  class Package
    extend DSL

    attr_reader :name, :app, :input_assets, :output_assets, :input_path,
                :output_path, :middlewares, :processors

    def initialize(name, app)
      @name, @app = name, app
      @input_assets, @output_assets = SortedSet.new, SortedSet.new
      @middlewares, @processors = [], []
    end

    def set_input(path)
      @input_path = path
    end

    def set_output(path)
      @output_path = path
    end

    def path
      output_path
    end

    def full_input_path
      File.expand_path(File.join(*[@app.input_path, @input_path].compact))
    end

    def full_output_path
      File.expand_path(File.join(*[@app.output_path, @output_path].compact))
    end

    def full_path
      full_output_path
    end

    def build_assets_from_paths(paths)
      paths.map do |path|
        Asset.new(self, path)
      end
    end

    def add_input_assets(assets)
      @input_assets.merge(assets)
    end

    def add_output_assets(assets)
      @output_assets.merge(assets)
    end

    def assets
      output_assets
    end

    def asset_paths
      output_assets.map { |asset| File.join(full_path, asset.basename) }
    end

    def server_path_for(asset)
      full_server_path_for(full_path, asset)
    end

    def full_server_path_for(full_path, asset)
      asset_path    = Pathname.new(File.join(full_path, asset.basename))
      app_path      = Pathname.new(@app.path)
      relative_path = asset_path.relative_path_from(app_path)
      server_path   = Pathname.new(@app.root) + relative_path
      server_path.cleanpath.to_s
    end

    def add_modifiers(modifiers)
      @processors += modifiers.map { |m| [:modify!, m] }
    end

    def add_concatenator(concat_name, concatenator = Concatenator.new)
      @processors << [:concat!, concat_name, concatenator]
    end

    def add_middleware(middleware, *args, &block)
      @middlewares << proc { |app| middleware.new(app, *args, &block) }
    end

    def handler
      handler_with_middlewares(asset_paths, full_path)
    end

    def handler_path
      build_handler_path(path)
    end

    def owns_any?(*paths)
      @input_assets.any? { |a| paths.include?(a.input_path) }
    end

    def process!(timestamped_output_path = nil)
      copy!
      !@processors.empty? && @processors.each do |instructions|
        send(*instructions)
      end
      write_files!(timestamped_output_path)
    end

    def modify!(modifier)
      @output_assets.each do |asset|
        asset.modify!(modifier)
      end
    end

    def concat!(concat_name, concatenator)
      asset = Asset.new(self)
      asset.content  = concatenator.call(@output_assets.map(&:content))
      asset.basename = concat_name
      @output_assets.replace([asset])
    end

    def copy!
      assets = @input_assets.map(&:dup)
      @output_assets.replace(assets)
    end

    def write_files!(timestamped_output_path = nil)
      real_output_path = timestamped_output_path || full_output_path
      @output_assets.each do |asset|
        asset.write_file!(real_output_path)
      end
    end

    def build_handler_path(handler_path)
      hp = handler_path || '/'
      hp.insert(0, '/') unless hp[0] == '/'
      hp
    end

    def handler_with_middlewares(paths, full_path)
      handler = FileHandler.new(paths, full_path)
      return handler if @middlewares.empty?
      @middlewares.reverse.reduce(handler) { |app, proc| proc.call(app) }
    end

    dsl do
      def input(path)
        set_input(path)
      end

      def output(path)
        set_output(path)
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
          paths = Dir[File.join(full_input_path, pattern)]
          assets = build_assets_from_paths(paths)
          add_input_assets(assets)
        end
      end

      def modify(*modifiers, &block)
        modifiers << block if block_given?
        add_modifiers(modifiers)
      end

      def concat(*args)
        add_concatenator(*args)
      end

      def use(*args, &block)
        add_middleware(*args, &block) 
      end

      def host(expression, &block)
        self.instance_eval(&block) if self.app.env.is?(expression)
      end
    end

    class Development < SimpleDelegator
      def assets
        input_assets
      end

      def asset_paths
        input_assets.map { |asset| File.join(full_path, asset.basename) }
      end

      def path
        input_path
      end

      def full_path
        full_input_path
      end

      def handler_path
        build_handler_path(path)
      end

      def handler
        handler_with_middlewares(asset_paths, full_path)
      end

      def server_path_for(asset)
        full_server_path_for(full_path, asset)
      end
    end
  end
end
