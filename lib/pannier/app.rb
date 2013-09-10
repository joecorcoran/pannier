module Pannier
  class App
    extend DSL

    attr_reader :root, :source_path, :result_path, :behaviors, :packages

    def initialize
      @behaviors, @packages, @root = {}, [], '/'
    end

    def set_root(path)
      @root = path
    end

    def set_source(path)
      @source_path = File.expand_path(path)
    end

    def set_result(path)
      @result_path = File.expand_path(path)
    end

    def add_package(package)
      @packages << package
    end

    def [](package_name)
      @packages.find { |pkg| pkg.name == package_name }
    end

    def handler
      @handler ||= begin
        map = @packages.reduce({}) do |hash, pkg|
          hash[pkg.handler_path] ||= Rack::Cascade.new([])
          hash[pkg.handler_path].add(pkg.handler)
          hash
        end
        Rack::URLMap.new(map)
      end
    end

    def writer(env = nil)
      @writer ||= AssetWriter.new(self)
      @writer.set_env(env) if env
      @writer
    end

    def process!
      @packages.each(&:process!)
    end

    def call(env)
      req = Rack::Request.new(env)
      return API::Response.new(req, self).response if API.handles?(req)
      handler.call(env)
    end

    dsl do

      def root(path)
        set_root(path)
      end

      def source(path)
        set_source(path)
      end

      def result(path)
        set_result(path)
      end

      def behavior(name, &block)
        add_behavior(name, &block)
      end

      def package(name, &block)
        add_package(Package.build(name, self, &block))
      end

      private

        def add_behavior(name, &block)
          self.behaviors[name] = block
        end

    end

  end
end
