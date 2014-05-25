Feature: CLI: process command
  In order to process assets from the command line
  As a developer
  I want a process command

  Scenario: Process command with default arguments
    Given the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'
      """
    When I run `pannier process`
    Then the exit status should be 0

  Scenario: Process command with specified host environment
    Given these files exist
      | input/foo.js |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :foo do
        assets 'foo.js'
        env?('development') { output 'dev' }
        env?('production')  { output 'prd' }
      end
      """
    When I run `pannier process --env production`
    Then these files should exist
      | output/prd/foo.js |
    And these files should not exist
      | output/dev/foo.js |
    And the exit status should be 0

  Scenario: Process command with specified config path
    Given the file "some/path/.asset_config" contains
      """ruby
      input  'input'
      output 'output'
      """
    When I run `pannier process --config some/path/.asset_config`
    Then the exit status should be 0

  Scenario: Process only packages which own specified assets
    Given these files exist
      | input/a.css |
      | input/b.css |
      | input/c.css |
      | input/d.css |
      | input/e.css |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package(:foo) { assets 'a.css', 'b.css' }
      package(:bar) { assets 'c.css', 'd.css' }
      package(:baz) { assets 'e.css'          }
      """
    When I run `pannier process --assets input/b.css,input/e.css`
    Then these files should exist
      | output/a.css |
      | output/b.css |
      | output/e.css |
    And these files should not exist
      | output/c.css |
      | output/d.css |
    And the exit status should be 0

  Scenario: Missing config file
    When I run `pannier process`
    Then the output should match /^Pannier config file not found at .+\.assets.rb\.$/
    And the exit status should be 1
