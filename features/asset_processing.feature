Feature: Asset processing
  In order that my assets are optimised for production
  As a developer
  I want my assets to be processed and copied from source to result directory

  Scenario: Assets copied from source to result directory
    Given these files exist
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
    Then these files should exist
      | fixtures/processed/bar.js |
      | fixtures/processed/baz.js |

  Scenario: Assets copied from nested source to nested result directory
    Given these files exist
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
    Then these files should exist
      | fixtures/processed/baz/qux.js  |
      | fixtures/processed/baz/quux.js |

  Scenario: Assets processed through process block before copying
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
          process do |content|
            content.reverse
          end
        end
      end
      """
    When the app has run
    Then the file at "fixtures/processed/qux.js" should contain
      """
      /* tnemmoc */
      """

  Scenario: Assets processed through process block and then concatenated
    Given the file at "fixtures/source/a.js" contains
      """
      /* one */
      """
    And the file at "fixtures/source/b.js" contains
      """
      /* two */
      """
    And the app is set up like
      """
      Pannier::App.new do
        source 'fixtures/source'
        result 'fixtures/processed'

        package 'main' do
          assets '*.js'
          process do |content|
            content.reverse
          end
          concat 'main.js'
        end
      end
      """
    When the app has run
    Then the file at "fixtures/processed/main.js" should contain
      """
      /* eno */
      /* owt */
      """

  Scenario: Assets concatenated by user proc
    Given the file at "fixtures/source/a.js" contains
      """
      /* one */
      """
    And the file at "fixtures/source/b.js" contains
      """
      /* two */
      """
    And the app is set up like
      """
      Pannier::App.new do
        source 'fixtures/source'
        result 'fixtures/processed'

        package 'main' do
          assets '*.js'
          concat 'main.js', proc { |contents| contents.reverse.join("\n") }
        end
      end
      """
    When the app has run
    Then the file at "fixtures/processed/main.js" should contain
      """
      /* two */
      /* one */
      """
