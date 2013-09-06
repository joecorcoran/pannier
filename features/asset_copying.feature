Feature: Asset copying
  In order that my source assets and result assets are separated
  As a developer
  I want to copy my source assets from one directory to the other

  Scenario: Assets copied from source to result directory
    Given these files exist
      | fixtures/source/bar.js |
      | fixtures/source/baz.js |
    And the app is configured as follows
      """ruby
      Pannier.build do
        source 'fixtures/source'
        result 'fixtures/processed'

        package :foo do
          assets '*.js'
        end
      end
      """
    When the app has been processed
    Then these files should exist
      | fixtures/processed/bar.js |
      | fixtures/processed/baz.js |

  Scenario: Assets copied from nested source to nested result directory
    Given these files exist
      | fixtures/source/bar/qux.js  |
      | fixtures/source/bar/quux.js |
    And the app is configured as follows
      """ruby
      Pannier.build do
        source 'fixtures/source'
        result 'fixtures/processed'

        package :foo do
          source 'bar'
          result 'baz'
          assets '*.js'
        end
      end
      """
    When the app has been processed
    Then these files should exist
      | fixtures/processed/baz/qux.js  |
      | fixtures/processed/baz/quux.js |
