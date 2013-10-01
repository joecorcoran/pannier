Feature: Command line interface
  In order to process assets outside of a host application
  As a developer
  I want a command line interface

  Scenario: Default command displays usage instructions
    When I run `pannier`
    Then the output should contain:
      """
      Available commands
      """
    And the exit status should be 0

  Scenario: Viewing usage instructions
    When I run `pannier usage`
    Then the output should contain:
      """
      Available commands
      """
    And the exit status should be 0

  Scenario: Process command with default arguments
    Given the file "fixtures/Pannierfile" contains
      """ruby
      input  'fixtures/input'
      output 'fixtures/output'
      """
    When I run `pannier process`
    Then the exit status should be 0

  Scenario: Process command with specified host environment
    Given these files exist
      | fixtures/input/foo.js |
    And the file "fixtures/Pannierfile" contains
      """ruby
      input  'fixtures/input'
      output 'fixtures/output'

      package :foo do
        assets 'foo.js'
        host('development') { output 'dev' }
        host('production')  { output 'prd' }
      end
      """
    When I run `pannier process --environment production`
    Then these files should exist
      | fixtures/output/prd/foo.js |
    And the exit status should be 0

  Scenario: Process command with specified config path
    Given the file "fixtures/some/path/.asset_config" contains
      """ruby
      input  'fixtures/input'
      output 'fixtures/output'
      """
    When I run `pannier process --config some/path/.asset_config`
    Then the exit status should be 0

  @pro
  Scenario: Missing config file
    When I run `pannier process`
    Then the output should match /^Pannier config file not found at.+Pannierfile\.$/
    And the exit status should be 1

  Scenario: Incorrect command
    When I run `pannier baz quux`
    Then the output should contain:
      """
      You ran `pannier baz quux`.
      Pannier has no command named "baz".
      """
    And the exit status should be 127
