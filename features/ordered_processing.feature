Feature: Ordered processing
  In order that I can continue to modify assets after concatenation
  As a developer
  I want all processing to happen in the declared order

  Scenario: Assets are modified after concatenation
    Given the file "input/bar.css" contains
      """css
      html {
        font-size: 24px;
      }
      """
    And the file "input/baz.css" contains
      """css
      body {
        background: green;
      }
      """
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'input'
        output 'output'

        package :styles do
          assets '*.css'
          modify do |content, basename|
            ["/* #{basename} */\n#{content}", basename]
          end
          concat 'styles.css'
          modify do |content, basename|
            ["/* Stylesheet Corp. LLC 2013 */\n#{content}", basename]
          end
        end
      end
      """
    When the app has been processed
    Then the file "output/styles.css" should contain
      """css
      /* Stylesheet Corp. LLC 2013 */
      /* bar.css */
      html {
        font-size: 24px;
      }
      /* baz.css */
      body {
        background: green;
      }
      """
