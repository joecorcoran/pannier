Feature: Logging
  In order to debug asset processing
  As a developer
  I want to see some logs

  @io
  Scenario: Logging to stdout
    Given these files exist
      | input/bar.js |
      | input/baz.js |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'
      logger

      package :foo do
        assets '*.js'
        concat 'main.min.js'
      end
      """
    When the app is loaded
    And the app has been processed
    Then stdout should match
      """
        Package :foo
          -> Input
            /.+/input/bar.js
            /.+/input/baz.js
          -> Output
            /.+/output/main.min.js

      """
