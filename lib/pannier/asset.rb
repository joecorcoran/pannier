module Pannier
  class Asset
    include Comparable

    attr_accessor :basename, :dirname

    def initialize(basename, dirname, package)
      @basename, @dirname, @package = basename, dirname, package
    end

    def path
      File.join(@dirname, @basename)
    end

    def content
      return unless File.exists?(path)
      @content = @content || File.read(path)
    end

    def content=(string)
      @content = string
    end

    def eql?(other)
      path == other.path
    end

    def hash
      path.hash
    end

    def <=>(other)
      path <=> other.path
    end

    def copy_to(to_dirname)
      copy = self.dup
      copy.content = content.dup
      copy.dirname = to_dirname
      copy
    end

    def write!
      FileUtils.mkdir_p(@dirname)
      File.open(path, 'w+') do |file|
        file << @content
      end
    end
  end
end
