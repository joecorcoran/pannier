module Pannier
  class Asset
    include Comparable

    attr_accessor :path

    def initialize(path, package)
      @path, @package = path, package
    end

    def content
      return unless File.exists?(@path)
      @content = @content || File.read(@path)
    end

    def content=(string)
      @content = string
    end

    def eql?(other)
      File.expand_path(path) == File.expand_path(other.path)
    end

    def hash
      File.expand_path(path).hash
    end

    def <=>(other)
      path <=> other.path
    end

    def copy_to(to_path)
      copy = self.dup
      copy.content = content.dup
      copy.path = to_path
      copy
    end

    def write!
      FileUtils.mkdir_p(File.dirname(@path))
      File.open(@path, 'w+') do |file|
        file << @content
      end
    end
  end
end
