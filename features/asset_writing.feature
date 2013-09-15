Feature: Writing assets
  In order to use my assets in a site
  As a developer
  I want to write the HTML that will include my assets on the page

  Scenario: Writing JavaScript assets
    Given these files exist
      | fixtures/input/one.js |
      | fixtures/input/two.js |
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'fixtures/input'
        output 'fixtures/output'

        package :scripts do
          assets '*.js'
        end
      end
      """
    And the app has been processed
    And an asset writer for the app has been instantiated
    When I use the asset writer as follows
      """ruby
      @writer.write(:js, :scripts, :defer => 'defer')
      """
    Then the following HTML should be written to the page
      """html
      <script type="text/javascript" src="/one.js" defer="defer"></script>
      <script type="text/javascript" src="/two.js" defer="defer"></script>
      """

  Scenario: Writing CSS assets
    Given these files exist
      | fixtures/input/a.css |
      | fixtures/input/b.css |
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'fixtures/input'
        output 'fixtures/output'

        package :styles do
          assets '*.css'
        end
      end
      """
    And the app has been processed
    And an asset writer for the app has been instantiated
    When I use the asset writer as follows
      """ruby
      @writer.write(:css, :styles, :media => 'screen')
      """
    Then the following HTML should be written to the page
      """html
      <link rel="stylesheet" type="text/css" href="/a.css" media="screen" />
      <link rel="stylesheet" type="text/css" href="/b.css" media="screen" />
      """

  Scenario: Writing assets from a mounted app
    Given these files exist
      | fixtures/input/foo.css |
    And the app is configured as follows
      """ruby
      Pannier.build do
        root   '/assets'
        input  'fixtures/input'
        output 'fixtures/output'

        package :styles do
          assets 'foo.css'
        end
      end
      """
    And the app has been processed
    And an asset writer for the app has been instantiated
    When I use the asset writer as follows
      """ruby
      @writer.write(:css, :styles)
      """
    Then the following HTML should be written to the page
      """html
      <link rel="stylesheet" type="text/css" href="/assets/foo.css" />
      """  
