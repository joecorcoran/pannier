Feature: Writing assets
  In order to use my assets in a site
  As a developer
  I want to write the HTML that will include my assets on the page

  Background:
    Given this code has executed
      """ruby
      require 'pannier/mounted'
      """

  Scenario: Writing JavaScript assets in production
    Given these files exist
      | input/scripts/one.js |
      | input/scripts/two.js |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :scripts do
        input  'scripts'
        assets '*.js'
      end
      """
    And the app is loaded in a production environment
    And the app has been processed
    When I write the tags as follows
      """ruby
      tags = Pannier::Tags.new(@app)
      tags.write(:scripts, :as => Pannier::Tags::JavaScript, :defer => 'defer')
      """
    Then the following HTML should be written to the page
      """html
      <script defer="defer" src="/one.js" type="text/javascript"></script>
      <script defer="defer" src="/two.js" type="text/javascript"></script>
      """

  Scenario: Writing CSS assets in production
    Given these files exist
      | input/styles/a.css |
      | input/styles/b.css |
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :styles do
        input  'styles'
        assets '*.css'
      end
      """
    And the app is loaded in a production environment
    And the app has been processed
    When I write the tags as follows
      """ruby
      tags = Pannier::Tags.new(@app)
      tags.write(:styles, :as => Pannier::Tags::CSS, :media => 'screen')
      """
    Then the following HTML should be written to the page
      """html
      <link href="/a.css" media="screen" rel="stylesheet" type="text/css" />
      <link href="/b.css" media="screen" rel="stylesheet" type="text/css" />
      """

  Scenario: Writing assets from a mounted app in production
    Given these files exist
      | input/styles/foo.css |
    And the file ".assets.rb" contains
      """ruby
      mount  '/assets'
      
      input  'input'
      output 'output'

      package :styles do
        input  'styles'
        assets 'foo.css'
      end
      """
    And the app is loaded in a production environment
    And the app has been processed
    When I write the tags as follows
      """ruby
      tags = Pannier::Tags.new(@app)
      tags.write(:styles, :as => Pannier::Tags::CSS)
      """
    Then the following HTML should be written to the page
      """html
      <link href="/assets/foo.css" rel="stylesheet" type="text/css" />
      """
