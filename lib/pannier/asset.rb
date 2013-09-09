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

    def env_path(env, base)
      prefix = env['SCRIPT_NAME'].to_s
      prefix = '/' if prefix.empty?
      asset_path, base_path = Pathname.new(path), Pathname.new(base)
      relative_path = asset_path.relative_path_from(base_path)
      prefix + relative_path.to_s
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
