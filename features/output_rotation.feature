Feature: Output directory rotation
  In order that old assets are still available to cached views
  As a crazy fragment cache person
  I want processed assets to output into timestamped directories

  Background:
    Given these files exist
      | input/foo.js |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'
      rotate 3

      package :js do
        assets '*.js'
      end
      """
    And the app is loaded in a production environment

  Scenario: Files are output to timestamped directory
    Given the app was processed at 09:30 on 2013-10-10
    Then these files should exist
      | output/1381397400/foo.js |

  Scenario: A timestamped directory is created each time the app is processed
    Given the app was processed at 09:30 on 2013-10-10
    And the app was processed at 09:35 on 2013-10-10
    And the app was processed at 09:40 on 2013-10-10
    Then these files should exist
      | output/1381397400/foo.js |
      | output/1381397700/foo.js |
      | output/1381398000/foo.js |

  Scenario: Oldest timestamped directory outside of limit is removed
    Given the app was processed at 09:30 on 2013-10-10
    And the app was processed at 09:35 on 2013-10-10
    And the app was processed at 09:40 on 2013-10-10
    And the app was processed at 09:45 on 2013-10-10
    Then these files should exist
      | output/1381397700/foo.js |
      | output/1381398000/foo.js |
      | output/1381398300/foo.js |
    And these files should not exist
      | output/1381397400/foo.js |
