Feature: Asset processing
  In order that my assets are optimised for production
  As a developer
  I want my assets to be processed and copied from source to result directory

  Scenario: Assets copied from source to result directory
    Given these files exist
      | fixtures/source/bar.js |
      | fixtures/source/baz.js |
    And the app is configured as follows
      """ruby
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
    And the app is configured as follows
      """ruby
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
    Given the file "fixtures/source/qux.js" contains
      """javascript
      /* comment */
      """
    And the app is configured as follows
      """ruby
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
    Then the file "fixtures/processed/qux.js" should contain
      """javascript
      /* tnemmoc */
      """

  Scenario: Assets processed through processors before copying
    Given the file "fixtures/source/qux.js" contains
      """javascript
      /* comment */
      """
    And a loaded ruby file contains
      """ruby
      class Exclaimifier
        def call(content)
          content.gsub(/(\w+)/, '\1!')
        end
      end

      class Reversifier
        def call(content)
          content.reverse
        end
      end
      """
    And the app is configured as follows
      """ruby
      Pannier::App.new do
        source 'fixtures/source'
        result 'fixtures/processed'

        package 'foo' do
          assets '*.js'
          process Exclaimifier.new, Reversifier.new
        end
      end
      """
    When the app has run
    Then the file "fixtures/processed/qux.js" should contain
      """javascript
      /* !tnemmoc */
      """

  Scenario: Assets processed through process block and then concatenated
    Given the file "fixtures/source/a.js" contains
      """javascript
      /* one */
      """
    And the file "fixtures/source/b.js" contains
      """javascript
      /* two */
      """
    And the app is configured as follows
      """ruby
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
    Then the file "fixtures/processed/main.js" should contain
      """javascript
      /* eno */
      /* owt */
      """

  Scenario: Assets concatenated by user proc
    Given the file "fixtures/source/a.js" contains
      """javascript
      /* one */
      """
    And the file "fixtures/source/b.js" contains
      """javascript
      /* two */
      """
    And the app is configured as follows
      """ruby
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
    Then the file "fixtures/processed/main.js" should contain
      """javascript
      /* two */
      /* one */
      """
