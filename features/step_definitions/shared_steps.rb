Given(/^that this feature is pending$/) do
  pending
end

Given(/^the app is configured as follows$/) do |string|
  @app = eval(string)
end

Given(/^these files exist$/) do |table|
  table.raw.flatten.each do |file_path|
    FileUtils.mkdir_p(File.dirname(file_path))
    File.new(file_path, 'w+')
  end
end

When(/^the app has been processed$/) do
  @app.process!
end

Then(/^these files should exist$/) do |table|
  file_paths = table.rows.flatten
  expect(file_paths.all? { |f| File.exists?(f) }).to be_true
end

Given(/^the file "(.*?)" contains$/) do |file_path, content|
  FileUtils.mkdir_p(File.dirname(file_path))
  File.open(file_path, 'w+') do |f|
    f << content
  end
end

Given(/^a loaded ruby file contains$/) do |string|
  eval(string)
end

Then(/^the file "(.*?)" should contain$/) do |file_path, content|
  expect(File.exists?(file_path)).to be_true
  expect(File.read(file_path)).to eq content
end
