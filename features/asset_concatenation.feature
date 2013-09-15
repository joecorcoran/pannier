Feature: Asset concatenation
  In order that my assets are delivered by as few requests as possible
  As a developer
  I want to concatenate multiple assets into one file

  Scenario: Assets are concatenated
    Given the file "fixtures/input/a.js" contains
      """javascript
      /* one */
      """
    And the file "fixtures/input/b.js" contains
      """javascript
      /* two */
      """
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'fixtures/input'
        output 'fixtures/output'

        package :main do
          assets '*.js'
          concat 'main.js'
        end
      end
      """
    When the app has been processed
    Then the file "fixtures/output/main.js" should contain
      """javascript
      /* one */
      /* two */
      """

  Scenario: Assets concatenated by user concatenator
    Given the file "fixtures/input/a.js" contains
      """javascript
      var a = 1;
      """
    And the file "fixtures/input/b.js" contains
      """javascript
      var b = 2;
      """
    And a loaded ruby file contains
      """ruby
      class ConcatWithBanner
        def initialize(message)
          @message = message
        end
        def call(content_array)
          content = "/* #{@message} */\n"
          content << content_array.join
          content
        end
      end
      """
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'fixtures/input'
        output 'fixtures/output'

        package :main do
          assets '*.js'
          concat 'main.js', ConcatWithBanner.new('Made by Computer Corp. LLC')
        end
      end
      """
    When the app has been processed
    Then the file "fixtures/output/main.js" should contain
      """javascript
      /* Made by Computer Corp. LLC */
      var a = 1;var b = 2;
      """
