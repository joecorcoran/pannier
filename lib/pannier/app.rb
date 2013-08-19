module Pannier
  class App

    attr_reader :source_path, :packages

    def initialize(&block)
      @packages = []
      self.instance_eval(&block) if block_given?
      self
    end

    def source(path)
      @source_path = path
    end

    def package(name, &block)
      return unless block_given?
      @packages << Package.new(name, self, &block)
    end

  end
end
