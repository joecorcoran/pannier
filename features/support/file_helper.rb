module FileHelper

  extend self

  def fixture_path
    File.expand_path('fixtures')
  end

  def create_fixtures!
    FileUtils.mkdir_p(fixture_path)
  end

  def remove_fixtures!
    FileUtils.rm_r(fixture_path, :secure => true)
  end

end
