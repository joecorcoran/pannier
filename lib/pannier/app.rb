module Pannier
  class App

    attr_reader :source_path, :result_path, :packages, :manifest

    def initialize(&block)
      @packages, @manifest = [], Manifest.new(self)
      @responder = Responder.new(@manifest)
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
      @manifest.build!
    end

    def run!
      @packages.each(&:run!)
      @manifest.build!
    end

    def call(env)
      @responder.response(Rack::Request.new(env))
    end

  end
end
