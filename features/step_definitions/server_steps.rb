When(/^I request "(.*?)"$/) do |path|
  get(path)
end

Then(/^the response status should be (\d+)$/) do |code|
  code = code.to_i
  expect(last_response.status).to eq code
end

Then(/^I should see these headers$/) do |table|
  table.each_cells_row do |row|
    expect(last_response.headers[row[0].value]).to eq row[1].value
  end
end

Then(/^the response body should be$/) do |string|
  expect(last_response.body).to eq string
end

Then(/^the JSON response body should match$/) do |string|
  pattern = eval(string)
  expect(last_response.body).to match_json_expression(pattern)
end
