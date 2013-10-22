Feature: Output directory rotation
  In order that old assets are still available to cached views
  As a crazy fragment cache person
  I want processed assets to output into timestamped directories

  Scenario: Files are output to timestamped directory
    Given these files exist
      | input/foo.js |
      | input/bar.js |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'
      rotate 5

      package :js do
        assets 'foo.js', 'bar.js'
      end
      """
    And the app is loaded in a production environment
    And the app was processed at 09:30 on 2013-10-10
    Then these files should exist
      | output/1381397400/foo.js |
      | output/1381397400/bar.js |
