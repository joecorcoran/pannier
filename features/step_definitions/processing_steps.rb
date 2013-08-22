Given(/^this app$/) do |string|
  @app = eval(string)
end

Given(/^these source files:$/) do |table|
  table.hashes.each do |file|
    location = File.expand_path(file['location'])
    FileUtils.mkdir_p(location)
    File.open(File.join(location, file['name']), 'w+') do |f|
      f << "/* comment */\n"
    end
  end
end

When(/^the app has run$/) do
  @app.run!
end

Then(/^these result files should exist:$/) do |table|
  file_paths = table.hashes.map do |file|
    File.expand_path(File.join(file['location'], file['name']))
  end
  expect(file_paths.all? { |f| File.exists?(f) }).to be_true
end
