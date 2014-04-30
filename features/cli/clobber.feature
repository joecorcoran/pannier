Feature: CLI: clobber command
  In order to remove the files I generate
  As a developer
  I want a clobber command

  Background:
    Given these files exist
      | input/foo.js |

  Scenario: Clobbering everything in development
    Given the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'
      package :foo do
        assets 'foo.js'
      end
      """
    And the app is loaded
    And the app has been processed
    And these files exist
      | input/.assets.development.json |
      | output/foo.js                  |
    When I run `pannier clobber`
    Then these files should not exist
      | input/.assets.development.json |
      | output/foo.js                  |
    And the exit status should be 0

  Scenario: Clobbering everything with specified host environment
    Given the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'
      package :foo do
        assets 'foo.js'
      end
      """
    And the app is loaded in a production environment
    And the app has been processed
    And these files exist
      | input/.assets.production.json  |
      | output/foo.js                  |
    When I run `pannier clobber --env production`
    Then these files should not exist
      | input/.assets.production.json  |
      | output/foo.js                  |
    And the exit status should be 0

  Scenario: Clobbering with specified config path
    Given the file "some/path/.asset_config" contains
      """ruby
      input  'input'
      output 'output'
      """
    When I run `pannier clobber --config some/path/.asset_config`
    Then the exit status should be 0

  Scenario: Missing config file
    When I run `pannier clobber`
    Then the output should match /^Pannier config file not found at .+\.assets.rb\.$/
    And the exit status should be 1
