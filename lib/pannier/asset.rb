require 'tempfile'

module Pannier
  class Asset

    attr_reader :source_path, :result_path

    def initialize(source_path, result_path, package)
      @source_path, @result_path, @package = source_path, result_path, package
      @piped_content = File.read(@source_path)
    end

    def pipe(&block)
      @piped_content = yield(@piped_content)
      self
    end

    def write!
      FileUtils.mkdir_p(File.dirname(@result_path))
      File.open(@result_path, 'w+') do |file|
        file << @piped_content
      end
    end

    def eql?(other)
      File.expand_path(source_path) == File.expand_path(other.source_path)
    end

    def hash
      @hash ||= File.expand_path(source_path).hash
    end

  end
end
