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

    def absolute_path_from(base)
      asset_pathname, base_pathname = Pathname.new(path), Pathname.new(base)
      relative_pathname = asset_pathname.relative_path_from(base_pathname)
      '/' + relative_pathname.to_s
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
      copy.content = content.dup
      copy.dirname = to_dirname
      copy
    end

    def process!(processor)
      processed = processor.call(content, basename)
      self.content, self.basename = processed
    end

    def write_file!
      FileUtils.mkdir_p(@dirname)
      File.open(path, 'w+') do |file|
        file << content
      end
    end
  end
end
