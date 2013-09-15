Feature: JSON API
  In order to inspect my asset file paths for use in decoupled front end tests
  As a developer
  I want to make requests to a JSON API and receive asset path information

  Background:
    Given these files exist
      | fixtures/input/foo.js |
      | fixtures/input/bar.js |
      | fixtures/input/baz.js |
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'fixtures/input'
        output 'fixtures/output'

        package :main do
          assets 'foo.js'
        end
        package :admin do
          assets 'bar.js', 'baz.js'
          concat 'admin.js'
        end
      end
      """

  Scenario: Getting the asset report before the app has been processed
    When I request "/packages"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should match
      """ruby
      {
        'main' => {
          'input' => [
            %r{fixtures/input/foo.js$}
          ]
        },
        'admin' => {
          'input' => [
            %r{fixtures/input/bar.js$},
            %r{fixtures/input/baz.js$}
          ]
        }
      }
      """

  Scenario: Getting the asset report after the app has been processed
    When the app has been processed
    And I request "/packages"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should match
      """ruby
      {
        'main' => {
          'input' => [
            %r{fixtures/input/foo.js$}
          ],
          'output' => [
            %r{fixtures/output/foo.js$}
          ],
          'app' => [
            '/foo.js'
          ]
        },
        'admin' => {
          'input' => [
            %r{fixtures/input/bar.js$},
            %r{fixtures/input/baz.js$}
          ],
          'output' => [
            %r{fixtures/output/admin.js$}
          ],
          'app' => [
            '/admin.js'
          ]
        }
      }
      """

  Scenario: Getting report details for a package
    When the app has been processed
    And I request "/packages/main"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should match
      """ruby
      {
        'input' => [
          %r{fixtures/input/foo.js$}
        ],
        'output' => [
          %r{fixtures/output/foo.js$}
        ],
        'app' => [
          '/foo.js'
        ]
      }
      """

  Scenario: Getting report details for a package state
    When the app has been processed
    And I request "/packages/main/output"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should match
      """ruby
      [
        %r{fixtures/output/foo.js$}
      ]
      """
