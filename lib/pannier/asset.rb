require 'fileutils'
require 'pathname'

module Pannier
  class Asset
    include Comparable

    attr_accessor :basename, :dirname, :content

    def initialize(basename, dirname, package)
      @basename, @dirname, @package = basename, dirname, package
      @content = original_content
    end

    def path
      File.join(@dirname, @basename)
    end

    def original_content
      return unless File.exists?(path)
      @original_content ||= File.read(path)
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
      copy.content = content.dup if content
      copy.dirname = to_dirname
      copy
    end

    def modify!(modifier)
      modified = modifier.call(content, basename)
      self.content, self.basename = modified
    end

    def write_file!
      FileUtils.mkdir_p(@dirname)
      File.open(path, 'w+') do |file|
        file << content
      end
    end
  end
end
