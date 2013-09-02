When(/^(when )?I request "(.*?)"$/) do |_, path|
  get(path)
end

When(/^(when )?I request "(.*?)" with these headers$/) do |_, path, table|
  table.each_cells_row do |row|
    header(row[0].value, row[1].value)
  end
  get(path, {})
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

Then(/^I should not see these headers$/) do |table|
  unwanted = table.raw.flatten
  unwanted.each do |u|
    expect(last_response.headers.keys.include?(u)).to be_false
  end
end

Then(/^the response body should be$/) do |string|
  expect(last_response.body).to eq string
end

Then(/^the JSON response body should match$/) do |string|
  pattern = eval(string)
  expect(last_response.body).to match_json_expression(pattern)
end
