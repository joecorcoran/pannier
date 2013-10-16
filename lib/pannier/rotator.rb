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

    def rotate!(time = Time.now)
      if directory_paths.length >= @limit
        FileUtils.rm_r(directory_paths.last)
      end
      made = FileUtils.mkdir(File.join(@path, time.to_i.to_s))
      made.first
    end

    private

      def select_timestamped_directories(paths)
        selected = paths.select do |path|
          pathname = Pathname.new(path)
          pathname.directory? && pathname.basename.to_s =~ /^\d+$/
        end
        selected.sort.reverse
      end

  end
end
