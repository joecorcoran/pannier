require 'stringio'

Before('@io') do
  @_original_stdout = $stdout
  @_stdout = $stdout = StringIO.new
end

After('@io') do
  @_stdout = @_original_stdout
end

Before do
  FileHelper.create_fixtures!
  @dirs = [FileHelper.fixture_path]
  @aruba_timeout_seconds = RUBY_PLATFORM == 'java' ? 60 : 10
end

After do
  FileHelper.remove_fixtures!
end
