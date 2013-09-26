Before do
  FileHelper.create_fixtures!
  @dirs = [FileHelper.fixture_path]
  @aruba_timeout_seconds = 10
end

After do
  FileHelper.remove_fixtures!
end
