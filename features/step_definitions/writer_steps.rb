When(/^an asset writer for the app has been instantiated$/) do
  @writer = Pannier::AssetWriter.new(@app)
end

When(/^I use the asset writer as follows$/) do |code|
  @html = eval(code)
end

Then(/^the following HTML should be written to the page$/) do |string|
  expect(@html).to eq string
end
