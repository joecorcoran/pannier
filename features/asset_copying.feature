Feature: Asset copying
  In order that my input assets and output assets are kept separate
  As a developer
  I want to copy my assets from one directory to the other

  Scenario: Assets copied from input to output directory
    Given these files exist
      | input/bar.js |
      | input/baz.js |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :foo do
        assets '*.js'
      end
      """
    When the app is loaded
    And the app has been processed
    Then these files should exist
      | output/bar.js |
      | output/baz.js |

  Scenario: Assets copied from nested input directory to nested output directory
    Given these files exist
      | input/bar/qux.js  |
      | input/bar/quux.js |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :foo do
        input  'bar'
        output 'baz'
        assets '*.js'
      end
      """
    When the app is loaded
    And the app has been processed
    Then these files should exist
      | output/baz/qux.js  |
      | output/baz/quux.js |

  Scenario: Locals exposed to config
    Given these files exist
      | input/boom.js |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output _.env

      package :foo do
        assets '*.js'
      end
      """
    When the app is loaded
    And the app has been processed
    Then these files should exist
      | development/boom.js |

  Scenario: Locals exposed to package blocks
    Given these files exist
      | input/boom.js |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :foo do
        output _.env
        assets '*.js'
      end
      """
    When the app is loaded
    And the app has been processed
    Then these files should exist
      | output/development/boom.js |
