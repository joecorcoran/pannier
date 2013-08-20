require 'pannier'
require 'helpers/file_helper'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.order = 'random'
  config.mock_framework = :mocha
end
