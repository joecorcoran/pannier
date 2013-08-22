require 'bundler/setup'
require 'pannier'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.order = 'random'
  config.mock_framework = :mocha
  config.formatter = :progress
end
