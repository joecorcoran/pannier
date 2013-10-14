Feature: Package behaviors
  In order to avoid repetitive package setup
  As a developer
  I want to define behaviors and mix them into packages

  Scenario: Defining a behavior and using it in multiple packages
    Given the file "input/foo.js" contains
      """javascript
      /* comment */
      """
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      behavior :bar do
        modify do |content, basename|
          [content.reverse, basename]
        end
      end

      package :baz do
        behave :bar
        assets 'foo.js'
      end
      """
    And the app is loaded in a production environment
    And the app has been processed
    Then the file "output/foo.js" should contain
      """javascript
      /* tnemmoc */
      """
