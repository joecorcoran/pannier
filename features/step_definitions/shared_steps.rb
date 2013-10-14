Given(/^the app is configured as follows$/) do |string|
  in_fixtures do
    @app = eval(string)
  end
end

Given(/^the app is loaded$/) do
  in_fixtures do
    @app = Pannier.load('.assets.rb', 'development')
  end
end

Given(/^the app is loaded in a (.+) environment$/) do |env_name|
  in_fixtures do
    @app = Pannier.load('.assets.rb', env_name)
  end
end

Given(/^these files exist$/) do |table|
  in_fixtures do
    table.raw.flatten.each do |file_path|
      FileUtils.mkdir_p(File.dirname(file_path))
      File.new(file_path, 'w+')
    end
  end
end

When(/^the app has been processed$/) do
  @app.process!
end

Then(/^these files should exist$/) do |table|
  in_fixtures do
    table.raw.flatten.each do |file_path|
      expect(File.exists?(file_path)).to be_true
    end
  end
end

Then(/^these files should not exist$/) do |table|
  in_fixtures do
    table.raw.flatten.each do |file_path|
      expect(File.exists?(file_path)).to be_false
    end
  end
end

Given(/^the file "(.*?)" contains$/) do |file_path, content|
  in_fixtures do
    FileUtils.mkdir_p(File.dirname(file_path))
    File.open(file_path, 'w+') do |f|
      f << content
    end
  end
end

Given(/^a loaded ruby file contains$/) do |string|
  eval(string)
end

Then(/^the file "(.*?)" should contain$/) do |file_path, content|
  in_fixtures do
    expect(File.exists?(file_path)).to be_true
    expect(File.read(file_path)).to eq content
  end
end

Then(/^the file "(.*?)" should not include$/) do |file_path, content|
  in_fixtures do
    expect(File.exists?(file_path)).to be_true
    expect(File.read(file_path)).not_to match content
  end
end

Then(/^the JSON file "(.*?)" should match$/) do |file_path, content|
  in_fixtures do
    expect(File.exists?(file_path)).to be_true
    json = File.read(file_path)
    expected = eval(content)
    expect(MultiJson.load(json)).to match_json_expression(expected)
  end
end
