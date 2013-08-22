Feature: Package processing
  In order that my assets are production-ready
  As a developer
  I want all the assets in a package to be taken from their source directories,
    processed and written to the production directory

  Scenario: Default
    Given these source files:
      | location        | name   |
      | fixtures/source | bar.js |
      | fixtures/source | baz.js |
    And this app
      """
      Pannier::App.new do
        source 'fixtures/source'
        result 'fixtures/processed'

        package 'foo' do
          assets '*.js'
        end
      end
      """
    When the app has run
    Then these result files should exist:
      | location           | name   |
      | fixtures/processed | bar.js |
      | fixtures/processed | baz.js |

  Scenario: Nested package files
    Given these source files:
      | location            | name    |
      | fixtures/source/bar | qux.js  |
      | fixtures/source/bar | quux.js |
    And this app
      """
      Pannier::App.new do
        source 'fixtures/source'
        result 'fixtures/processed'

        package 'foo' do
          source 'bar'
          result 'baz'
          assets '*.js'
        end
      end
      """
    When the app has run
    Then these result files should exist:
      | location               | name    |
      | fixtures/processed/baz | qux.js  |
      | fixtures/processed/baz | quux.js |
