module Pannier
  class Asset

    attr_reader :source_path, :result_path

    def initialize(source_path, result_path, package)
      @source_path, @result_path, @package = source_path, result_path, package
    end

    def source_data
      @source_data ||= File.read(@source_path)
    end

    def write_result!
      FileUtils.mkdir_p(File.dirname(@result_path))
      File.open(@result_path, 'w+') do |file|
        file << source_data
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
