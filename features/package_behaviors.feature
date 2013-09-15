Feature: Package behaviors
  In order to avoid repetitive package setup
  As a developer
  I want to define behaviors and mix them into packages

  Scenario: Defining a behavior and using it in multiple packages
    Given the file "fixtures/input/foo.js" contains
      """javascript
      /* comment */
      """
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'fixtures/input'
        output 'fixtures/output'

        behavior :bar do
          modify do |content, basename|
            [content.reverse, basename]
          end
        end

        package :baz do
          behave :bar
          assets 'foo.js'
        end
      end
      """
    And the app has been processed
    When I request "/foo.js"
    Then the response body should be
      """javascript
      /* tnemmoc */
      """
