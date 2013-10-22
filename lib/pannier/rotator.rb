require 'fileutils'
require 'pathname'

module Pannier
  class Rotator

    def initialize(path, limit)
      @path, @limit = path, limit
    end

    def directory_paths
      paths = Dir[File.join(@path, '*')]
      select_timestamped_directories(paths)
    end

    def rotate(time = Time.now, &block)
      latest = push(time)
      begin
        block.call(latest) if block_given?
      rescue StandardError => error
        rollback
        raise error
      end
      pop
    end

    private

      def select_timestamped_directories(paths)
        selected = paths.select do |path|
          pathname = Pathname.new(path)
          pathname.directory? && pathname.basename.to_s =~ /^\d+$/
        end
        selected.sort.reverse
      end

      def push(time)
        created = FileUtils.mkdir_p(File.join(@path, time.to_i.to_s))
        created.first
      end

      def rollback
        FileUtils.rm_r(directory_paths.first)
      end

      def pop
        if directory_paths.length >= @limit
          FileUtils.rm_r(directory_paths.last)
        end  
      end

  end
end
