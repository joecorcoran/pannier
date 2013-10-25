require 'fileutils'
require 'pathname'

module Pannier
  class Asset
    include Comparable

    attr_accessor :input_path, :content
    attr_writer   :basename

    def initialize(package, input_path = nil)
      @package, @input_path = package, input_path
      @content = input_content
    end

    def input_content
      @input_content ||= begin
        return unless @input_path && File.exists?(@input_path)
        File.read(@input_path)
      end
    end

    def eql?(other)
      @input_path == other.input_path
    end

    def hash
      @input_path.hash
    end

    def <=>(other)
      @input_path <=> other.input_path
    end

    def basename
      @basename ||= Pathname.new(input_path).basename.to_s
    end

    def modify!(modifier)
      modified = modifier.call(content, basename)
      self.content, self.basename = modified
    end

    def write_file!(output_dir)
      FileUtils.mkdir_p(output_dir)
      output_path = File.join(output_dir, basename)
      File.open(output_path, 'w+') do |file|
        file << content
      end
    end
  end
end
