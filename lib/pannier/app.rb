require 'ostruct'

require 'pannier/dsl'
require 'pannier/environment'
require 'pannier/manifest_writer'
require 'pannier/package'

module Pannier
  class App
    extend DSL

    attr_reader :env, :root, :input_path, :output_path,
                :behaviors, :packages

    def initialize(env_name = 'development')
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

    def add_package(package)
      @packages << package
    end

    def [](package_name)
      @packages.find { |pkg| pkg.name == package_name }
    end

    def manifest_writer
      @manifest_writer ||= ManifestWriter.new(self, @env)
    end

    def process!
      @packages.each(&:process!)
      manifest_writer.write!(@input_path)
    end

    def process_owners!(*paths)
      pkgs = @packages.select { |pkg| pkg.owns_any?(*paths) }
      pkgs.each(&:process!)
    end

    dsl do

      def _
        @locals ||= OpenStruct.new(:env => env.name)
      end

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
        add_package(Package.build(name, __getobj__, &block))
      end

      private

        def add_behavior(name, &block)
          self.behaviors[name] = block
        end

    end

  end
end
