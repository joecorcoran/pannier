module Pannier
  class App

    attr_reader :source_path, :result_path, :packages, :manifest

    def initialize(&block)
      @packages, @manifest = [], Manifest.new(self)
      self.instance_eval(&block) if block_given?
      self
    end

    def source(path)
      @source_path = File.expand_path(path)
    end

    def result(path)
      @result_path = File.expand_path(path)
    end

    def package(name, &block)
      return unless block_given?
      @packages << Package.new(name, self, &block)
      @manifest.build_source!
    end

    def file_server
      @file_server ||= Rack::File.new(@result_path)
    end

    def process!
      @packages.each(&:process!)
      @manifest.build_result!
    end

    def call(env)
      req = Rack::Request.new(env)
      return API::Response.new(req, @manifest).response if API.handles?(req)
      file_server.call(env)
    end

  end
end
