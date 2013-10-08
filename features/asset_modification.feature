Feature: Asset modification
  In order that my assets are optimised for production
  As a developer
  I want to modify the content and filenames of my assets

  Scenario: Assets modified by modify block
    Given the file "input/qux.js" contains
      """javascript
      /* comment */
      """
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'input'
        output 'output'

        package :foo do
          assets '*.js'
          modify do |content, basename|
            [content.reverse, basename]
          end
        end
      end
      """
    When the app has been processed
    Then the file "output/qux.js" should contain
      """javascript
      /* tnemmoc */
      """

  Scenario: Assets modified by modifier
    Given the file "input/qux.js" contains
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
        input  'input'
        output 'output'

        package :foo do
          assets '*.js'
          modify Exclaimifier.new, Suffixer.new('abcde')
        end
      end
      """
    When the app has been processed
    Then the file "output/qux-abcde.js" should contain
      """javascript
      /* comment! */
      """
