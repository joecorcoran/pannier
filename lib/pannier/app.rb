module Pannier
  class App

    attr_reader :source_path, :result_path, :packages

    def initialize(&block)
      @packages = []
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
    end

    def run!
      @packages.each(&:run!)
    end

  end
end
