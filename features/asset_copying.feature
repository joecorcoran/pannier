Feature: Asset copying
  In order that my input assets and output assets are kept separate
  As a developer
  I want to copy my assets from one directory to the other

  Scenario: Assets copied from input  to output directory
    Given these files exist
      | fixtures/input/bar.js |
      | fixtures/input/baz.js |
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'fixtures/input'
        output 'fixtures/output'

        package :foo do
          assets '*.js'
        end
      end
      """
    When the app has been processed
    Then these files should exist
      | fixtures/output/bar.js |
      | fixtures/output/baz.js |

  Scenario: Assets copied from nested input  to nested output directory
    Given these files exist
      | fixtures/input/bar/qux.js  |
      | fixtures/input/bar/quux.js |
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'fixtures/input'
        output 'fixtures/output'

        package :foo do
          input  'bar'
          output 'baz'
          assets '*.js'
        end
      end
      """
    When the app has been processed
    Then these files should exist
      | fixtures/output/baz/qux.js  |
      | fixtures/output/baz/quux.js |
