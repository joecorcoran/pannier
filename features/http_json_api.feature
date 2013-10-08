Feature: HTTP JSON API
  In order to inspect my asset file paths
  As a developer
  I want to make requests to an HTTP API and receive asset information as JSON

  Background:
    Given these files exist
      | input/foo.js |
      | input/bar.js |
      | input/baz.js |
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'input'
        output 'output'

        package :main do
          assets 'foo.js'
        end
        package :admin do
          assets 'bar.js', 'baz.js'
          concat 'admin.js'
        end
      end
      """
    And the app has been processed

  Scenario: Getting the asset report after the app has been processed
    When I request "/packages"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should be
      """json
      {
        "main": [
          "http://example.org/foo.js"
        ],
        "admin": [
          "http://example.org/admin.js"
        ]
      }
      """

  Scenario: Getting report details for a package
    When I request "/packages/main"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should be
      """json
      [
        "http://example.org/foo.js"
      ]
      """

  Scenario: Requesting a package that does not exist
    When I request "/packages/quux"
    Then the response status should be 404
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should be
      """json
      {
        "status": 404,
        "message": "Not found"
      }
      """
