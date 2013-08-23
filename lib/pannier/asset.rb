require 'tempfile'

module Pannier
  class Asset
    include Comparable

    attr_reader :source_path, :result_path
    attr_accessor :content

    def initialize(source_path, result_path, package)
      @source_path, @result_path, @package = source_path, result_path, package
      @content = File.read(@source_path)
    end

    def write_result!
      FileUtils.mkdir_p(File.dirname(@result_path))
      File.open(@result_path, 'w+') do |file|
        file << @content
      end
    end

    def eql?(other)
      File.expand_path(source_path) == File.expand_path(other.source_path)
    end

    def hash
      @hash ||= File.expand_path(source_path).hash
    end

    def <=>(other)
      source_path <=> other.source_path
    end

  end
end
