Feature: Asset concatenation
  In order that my assets are delivered by as few requests as possible
  As a developer
  I want to concatenate multiple assets into one file

  Scenario: Assets are concatenated
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
      Pannier.build do
        source 'fixtures/source'
        result 'fixtures/processed'

        package :main do
          assets '*.js'
          concat 'main.js'
        end
      end
      """
    When the app has been processed
    Then the file "fixtures/processed/main.js" should contain
      """javascript
      /* one */
      /* two */
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
      Pannier.build do
        source 'fixtures/source'
        result 'fixtures/processed'

        package :main do
          assets '*.js'
          concat 'main.js', proc { |contents| contents.reverse.join("\n") }
        end
      end
      """
    When the app has been processed
    Then the file "fixtures/processed/main.js" should contain
      """javascript
      /* two */
      /* one */
      """
