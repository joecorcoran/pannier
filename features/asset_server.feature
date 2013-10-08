Feature: Serving assets
  In order that I can separate my assets from my application
  As a developer
  I want to deploy a separate app from which I can request my assets

  Background:
    Given the file "input/styles/foo.css" contains
      """css
      html { color: red; }
      """
    And the file "input/scripts/bar.js" contains
      """javascript
      var a = 1;
      """

  Scenario: Requesting a CSS file
    Given the app is configured as follows
      """ruby
      Pannier.build do
        input  'input'
        output 'output'

        package :styles do
          input  'styles'
          output 'styles'
          assets '*.css'
        end
      end
      """
    And the app has been processed
    When I request "/styles/foo.css"
    Then the response status should be 200
    And I should see these headers
      | Content-Type   | text/css |
      | Content-Length | 20       |
    And the response body should be
      """css
      html { color: red; }
      """

  Scenario: Requesting a JavaScript file
    Given the app is configured as follows
      """ruby
      Pannier.build do
        input  'input'
        output 'output'

        package :scripts do
          input  'scripts'
          output 'scripts'
          assets '*.js'
        end
      end
      """
    And the app has been processed
    When I request "/scripts/bar.js"
    Then the response status should be 200
    And I should see these headers
      | Content-Type   | application/javascript |
      | Content-Length | 10                     |
    And the response body should be
      """javascript
      var a = 1;
      """

  Scenario: Requesting a CSS file in development mode
    Given the app is configured as follows
      """ruby
      Pannier.build('development') do
        input  'input'
        output 'output'

        package :styles do
          input  'styles'
          output 'styles-out'
          assets '*.css'
        end
      end
      """
    When I request "/styles/foo.css"
    Then the response status should be 200
    And I should see these headers
      | Content-Type   | text/css |
      | Content-Length | 20       |
    And the response body should be
      """css
      html { color: red; }
      """
