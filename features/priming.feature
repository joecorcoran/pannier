Feature: App priming
  In order that a Pannier app can maintain processed state
  As a developer
  I want previously processed assets to be loaded from a manifest file

  Background:
    Given this code has executed
      """ruby
      require 'pannier/mounted'
      """

  Scenario: The app is loaded after a manifest has been generated
    Given these files exist
      | input/foo.js |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :scripts do
        assets 'foo.js'
      end
      """
    And I run `pannier process --env production`
    And the app is primed in a production environment
    When I request "/foo.js"
    Then the response status should be 200
