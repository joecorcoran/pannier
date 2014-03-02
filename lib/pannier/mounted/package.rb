require 'pannier/file_handler'
require 'pannier/package'

module Pannier
  class Package

    def add_middleware(middleware, *args, &block)
      @middlewares << proc { |app| middleware.new(app, *args, &block) }
    end

    def handler
      handler_with_middlewares(output_assets.map(&:path), full_output_path)
    end

    def handler_path
      build_handler_path(output_path)
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

      def use(*args, &block)
        add_middleware(*args, &block) 
      end

    end

  end
end
