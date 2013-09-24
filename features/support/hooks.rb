Before do
  FileHelper.create_fixtures!
end

Before do
  @dirs = [FileHelper.fixture_path]
end

After do
  FileHelper.remove_fixtures!
end
