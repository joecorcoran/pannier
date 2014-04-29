require 'ostruct'

require 'pannier/dsl'
require 'pannier/environment'
require 'pannier/logger'
require 'pannier/manifest_writer'
require 'pannier/package'

module Pannier
  class App
    extend DSL

    attr_reader :env, :input_path, :output_path,
                :behaviors, :packages, :logger

    def initialize(env_name = 'development')
      @env = Environment.new(env_name)
      @behaviors, @packages, @root = {}, [], '/'
    end

    def set_input(path)
      @input_path = File.expand_path(path)
    end

    def set_output(path)
      @output_path = File.expand_path(path)
    end

    def set_logger(logger)
      @logger = logger
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

    def clobber!
      manifest_writer.clobber!(@input_path)
      @packages.each(&:clobber!)
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

      def input(path)
        set_input(path)
      end

      def output(path)
        set_output(path)
      end

      def logger(logger = Pannier::Logger.new($stdout))
        set_logger(logger)
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
