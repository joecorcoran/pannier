Feature: Asset manifest
  In order to inspect my asset file paths for use in decoupled front end tests
  As a developer
  I want to request the asset manifest and receive a JSON response

  Background:
    Given these files exist
      | fixtures/source/foo.js |
    And the app is configured as follows
      """ruby
      Pannier::App.new do
        source 'fixtures/source'
        result 'fixtures/processed'

        package 'main' do
          assets '*.js'
        end
      end
      """

  Scenario: Getting the asset manifest before the app has run
    When I request "/manifest"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should match
      """ruby
      {
        :main => {
          :source => [
            %r{fixtures/source/foo.js$}
          ]
        }
      }
      """

  Scenario: Getting the asset manifest after the app has run
    When the app has run
    And I request "/manifest"
    Then the response status should be 200
    And I should see these headers
      | Content-Type | application/json |
    And the JSON response body should match
      """ruby
      {
        :main => {
          :source => [
            %r{fixtures/source/foo.js$}
          ],
          :result => [
            %r{fixtures/processed/foo.js$}
          ]
        }
      }
      """
