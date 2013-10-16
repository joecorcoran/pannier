require 'bundler/setup'
require 'rack'
require_relative '../features/support/file_helper'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.order = 'random'
  config.mock_framework = :mocha
  config.formatter = :progress
  config.include(FileHelper)
end
