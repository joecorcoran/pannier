module Pannier
  class App

    attr_reader :source_path, :result_path, :behaviors, :packages, :manifest

    def initialize(&block)
      @behaviors, @packages, @manifest = {}, [], Manifest.new(self)
      self.instance_eval(&block) if block_given?
      self
    end

    def source(path)
      @source_path = File.expand_path(path)
    end

    def result(path)
      @result_path = File.expand_path(path)
    end

    def behavior(name, &block)
      return unless block_given?
      @behaviors[name] = block
    end

    def package(name, &block)
      return unless block_given?
      @packages << Package.new(name, self, &block)
      @manifest.build_source!
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

    def process!
      @packages.each(&:process!)
      @manifest.build_result!
    end

    def call(env)
      req = Rack::Request.new(env)
      return API::Response.new(req, @manifest).response if API.handles?(req)
      handler.call(env)
    end

  end
end
