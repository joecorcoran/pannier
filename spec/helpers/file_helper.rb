require 'fileutils'

module FileHelper

  def self.fixture_path
    File.expand_path(File.join(File.dirname(__FILE__), '..', 'fixtures'))
  end

  def self.clean_processed_files!(path = 'processed')
    FileUtils.rm_r(Dir[File.join(fixture_path, path)], :secure => true)
  end

end
