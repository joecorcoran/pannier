When(/^I write the tags as follows$/) do |code|
  @html = eval(code)
end

Then(/^the following HTML should be written to the page$/) do |string|
  expect(@html).to eq string
end
