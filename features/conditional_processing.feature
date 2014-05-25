Feature: Conditional processing per host environment
  In order to process assets according to the environment of the host app
  As a developer
  I want to specify this in my package definitions

  Scenario: Assets are processed based on host environment
    Given these files exist
      | input/bar.js |
      | input/baz.js |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :foo do
        env? 'production' do
          concat 'foo.js'
        end
      end
      """
      And the app is loaded in a production environment
      And the app has been processed
      Then these files should exist
        | output/foo.js |
      And these files should not exist
        | output/bar.js |
        | output/baz.js |
