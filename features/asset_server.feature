@wip
Feature: Serving assets
  In order that I can use my assets
  As a developer
  I want to a Rack server that can serve assets

  Background:
    Given the file "input/styles/foo.css" contains
      """css
      html { color: red; }
      """
    And the file "input/scripts/bar.js" contains
      """javascript
      var a = 1;
      """

  Scenario: Requesting a CSS file in production
    Given the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :styles do
        input  'styles'
        assets '*.css'
      end
      """
    And the app is loaded in a production environment
    And the app has been processed
    When I request "/foo.css"
    Then the response status should be 200
    And I should see these headers
      | Content-Type   | text/css |
      | Content-Length | 20       |
    And the response body should be
      """css
      html { color: red; }
      """

  Scenario: Requesting a JavaScript file in production
    Given the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :scripts do
        input  'scripts'
        assets '*.js'
      end
      """
    And the app is loaded in a production environment
    And the app has been processed
    When I request "/bar.js"
    Then the response status should be 200
    And I should see these headers
      | Content-Type   | application/javascript |
      | Content-Length | 10                     |
    And the response body should be
      """javascript
      var a = 1;
      """

  Scenario: Requesting a file in development mode
    Given the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :styles do
        input  'styles'
        assets '*.css'
      end
      """
    And the app is loaded
    When I request "/styles/foo.css"
    Then the response status should be 200
    And I should see these headers
      | Content-Type   | text/css |
      | Content-Length | 20       |
    And the response body should be
      """css
      html { color: red; }
      """
