Before do
  FileHelper.create_fixtures!
end

After do
  FileHelper.remove_fixtures!
end
