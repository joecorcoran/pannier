Before do
  FileHelper.create_fixtures!
  @dirs = [FileHelper.fixture_path]
  @aruba_timeout_seconds = RUBY_PLATFORM == 'java' ? 60 : 10
end

After do
  FileHelper.remove_fixtures!
end
