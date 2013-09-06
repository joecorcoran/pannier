Feature: Asset processing
  In order that my assets are optimised for production
  As a developer
  I want my assets to be processed

  Scenario: Assets processed by process block
    Given the file "fixtures/source/qux.js" contains
      """javascript
      /* comment */
      """
    And the app is configured as follows
      """ruby
      Pannier.build do
        source 'fixtures/source'
        result 'fixtures/processed'

        package :foo do
          assets '*.js'
          process do |content, basename|
            [content.reverse, basename]
          end
        end
      end
      """
    When the app has been processed
    Then the file "fixtures/processed/qux.js" should contain
      """javascript
      /* tnemmoc */
      """

  Scenario: Assets processed by processors
    Given the file "fixtures/source/qux.js" contains
      """javascript
      /* comment */
      """
    And a loaded ruby file contains
      """ruby
      class Exclaimifier
        def call(content, basename)
          [content.gsub(/(\w+)/, '\1!'), basename]
        end
      end
      """
    And a loaded ruby file contains
      """ruby
      class Suffixer
        def initialize(suffix)
          @suffix = suffix
        end

        def call(content, basename)
          ext = File.extname(basename)
          base = File.basename(basename, ext)
          [content, "#{base}-#{@suffix}#{ext}"]
        end
      end
      """
    And the app is configured as follows
      """ruby
      Pannier.build do
        source 'fixtures/source'
        result 'fixtures/processed'

        package :foo do
          assets '*.js'
          process Exclaimifier.new, Suffixer.new('abcde')
        end
      end
      """
    When the app has been processed
    Then the file "fixtures/processed/qux-abcde.js" should contain
      """javascript
      /* comment! */
      """
