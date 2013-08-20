module Pannier
  class Asset

    attr_reader :source_path, :result_path

    def initialize(source_path, result_path, package)
      @source_path, @result_path, @package = source_path, result_path, package
    end

    def pipe(&block)
      self.tmp = yield(tmp)
      self
    end

    def write!
      FileUtils.mkdir_p(File.dirname(@result_path))
      File.open(@result_path, 'w+') do |file|
        file << tmp
      end
      clean_up!
    end

    def eql?(other)
      File.expand_path(source_path) == File.expand_path(other.source_path)
    end

    def hash
      @hash ||= File.expand_path(source_path).hash
    end

    private

      def tmp
        setup_tmp!
        File.read(tmp_path)
      end

      def tmp=(contents)
        File.open(tmp_path, 'w') do |file|
          file << contents
        end
      end

      def tmp_path
        File.join(@package.source_path, "tmp-#{hash.abs.to_s}")
      end

      def setup_tmp!
        self.tmp = File.read(@source_path) unless File.exists?(tmp_path)
      end

      def clean_up!
        File.delete(tmp_path)
      end

  end
end
