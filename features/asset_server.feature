Feature: Serving assets
  In order that I can separate my assets from my application
  As a developer
  I want to deploy a separate app from which I can request my assets

  Background:
    Given the file "fixtures/source/styles/foo.css" contains
      """css
      html { color: red; }
      """
    And the file "fixtures/source/scripts/bar.js" contains
      """javascript
      var a = 1;
      """
    And the app is configured as follows
      """ruby
      Pannier.build do
        source 'fixtures/source'
        result 'fixtures/result'

        package :styles do
          source 'styles'
          result 'styles'
          assets '*.css'
        end
        package :scripts do
          source 'scripts'
          result 'scripts'
          assets '*.js'
        end
      end
      """
    And the app has been processed

  Scenario: Requesting a CSS result file
    When I request "/styles/foo.css"
    Then the response status should be 200
    And I should see these headers
      | Content-Type   | text/css |
      | Content-Length | 20       |
    And the response body should be
      """css
      html { color: red; }
      """

  Scenario: Requesting a JavaScript result file
    When I request "/scripts/bar.js"
    Then the response status should be 200
    And I should see these headers
      | Content-Type   | application/javascript |
      | Content-Length | 10                     |
    And the response body should be
      """javascript
      var a = 1;
      """
