Feature: Package processing
  In order that my assets are production-ready
  As a developer
  I want all the assets in a package to be taken from their source directories,
    processed and written to the production directory

  Scenario: Assets in app source directory, unprocessed
    Given these files exist:
      | fixtures/source/bar.js |
      | fixtures/source/baz.js |
    And the app is set up like
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
    Then these files should exist:
      | fixtures/processed/bar.js |
      | fixtures/processed/baz.js |

  Scenario: Assets in own nested directory, unprocessed
    Given these files exist:
      | fixtures/source/bar/qux.js  |
      | fixtures/source/bar/quux.js |
    And the app is set up like
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
    Then these files should exist:
      | fixtures/processed/baz/qux.js  |
      | fixtures/processed/baz/quux.js |

  Scenario: Processing assets through process block
    Given the file at "fixtures/source/qux.js" contains
      """
      /* comment */

      """
    And the app is set up like
      """
      Pannier::App.new do
        source 'fixtures/source'
        result 'fixtures/processed'

        package 'foo' do
          assets '*.js'
          process do |asset|
            asset.pipe { |content| content.gsub!(/o/, '0') }
          end
        end
      end
      """
    When the app has run
    Then the file at "fixtures/processed/qux.js" should contain
      """
      /* c0mment */

      """
