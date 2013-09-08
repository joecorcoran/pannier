When(/^an asset writer for the app exists$/) do
  @writer = Pannier::AssetWriter.new(@app)
end

When(/^I use the writer as follows$/) do |code|
  @html = eval(code)
end

Then(/^the following HTML should be written to the page$/) do |string|
  expect(@html).to eq string
end
