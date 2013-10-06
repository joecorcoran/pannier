require 'pannier/api'
require 'pannier/dsl'
require 'pannier/environment'
require 'pannier/package'

module Pannier
  class App
    extend DSL

    attr_reader :env, :root, :input_path, :output_path,
                :behaviors, :packages

    def initialize(env_name = nil)
      @env = Environment.new(env_name)
      @behaviors, @packages, @root = {}, [], '/'
    end

    def set_root(path)
      @root = path
    end

    def set_input(path)
      @input_path = File.expand_path(path)
    end

    def set_output(path)
      @output_path = File.expand_path(path)
    end

    def path
      @env.development_mode? ? @input_path : @output_path
    end

    def add_package(package)
      package = Package::Development.new(package) if @env.development_mode?
      @packages << package
    end

    def [](package_name)
      @packages.find { |pkg| pkg.name == package_name }
    end

    def process!
      @packages.each(&:process!)
    end

    def process_owners!(*paths)
      pkgs = @packages.select { |pkg| pkg.owns_any?(*paths) }
      pkgs.each(&:process!)
    end

    def handler_map
      @packages.reduce({}) do |hash, pkg|
        hash[pkg.handler_path] ||= Rack::Cascade.new([])
        hash[pkg.handler_path].add(pkg.handler)
        hash
      end
    end

    def handler
      Rack::Cascade.new(
        [
          API::Handler.new(self),
          Rack::URLMap.new(handler_map)
        ],
        [500]
      )
    end

    def call(env)
      handler.call(env)
    end

    dsl do

      def root(path)
        set_root(path)
      end

      def input(path)
        set_input(path)
      end

      def output(path)
        set_output(path)
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
