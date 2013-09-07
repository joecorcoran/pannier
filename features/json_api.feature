Feature: JSON API
  In order to inspect my asset file paths for use in decoupled front end tests
  As a developer
  I want to make requests to a JSON API and receive asset path information

  Background:
    Given these files exist
      | fixtures/source/foo.js |
      | fixtures/source/bar.js |
      | fixtures/source/baz.js |
    And the app is configured as follows
      """ruby
      Pannier.build do
        source 'fixtures/source'
        result 'fixtures/processed'

        package :main do
          assets 'foo.js'
        end
        package :admin do
          assets 'bar.js', 'baz.js'
          concat 'admin.js'
        end
      end
      """

  Scenario: Getting the asset manifest before the app has been processed
    When I request "/packages"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should match
      """ruby
      {
        'main' => {
          'source' => [
            %r{fixtures/source/foo.js$}
          ]
        },
        'admin' => {
          'source' => [
            %r{fixtures/source/bar.js$},
            %r{fixtures/source/baz.js$}
          ]
        }
      }
      """

  Scenario: Getting the asset manifest after the app has been processed
    When the app has been processed
    And I request "/packages"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should match
      """ruby
      {
        'main' => {
          'source' => [
            %r{fixtures/source/foo.js$}
          ],
          'result' => [
            %r{fixtures/processed/foo.js$}
          ]
        },
        'admin' => {
          'source' => [
            %r{fixtures/source/bar.js$},
            %r{fixtures/source/baz.js$}
          ],
          'result' => [
            %r{fixtures/processed/admin.js$}
          ]
        }
      }
      """

  Scenario: Getting manifest details for a package
    When the app has been processed
    And I request "/packages/main"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should match
      """ruby
      {
        'source' => [
          %r{fixtures/source/foo.js$}
        ],
        'result' => [
          %r{fixtures/processed/foo.js$}
        ]
      }
      """

  Scenario: Getting manifest details for a package state
    When the app has been processed
    And I request "/packages/main/result"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should match
      """ruby
      [
        %r{fixtures/processed/foo.js$}
      ]
      """
