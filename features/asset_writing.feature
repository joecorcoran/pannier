Feature: Writing assets
  In order to use my assets in a site
  As a developer
  I want to write the HTML that will include my assets on the page

  Scenario: Writing JavaScript assets
    Given these files exist
      | input/one.js |
      | input/two.js |
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'input'
        output 'output'

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
      <script defer="defer" src="/one.js" type="text/javascript"></script>
      <script defer="defer" src="/two.js" type="text/javascript"></script>
      """

  Scenario: Writing CSS assets
    Given these files exist
      | input/a.css |
      | input/b.css |
    And the app is configured as follows
      """ruby
      Pannier.build do
        input  'input'
        output 'output'

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
      <link href="/a.css" media="screen" rel="stylesheet" type="text/css" />
      <link href="/b.css" media="screen" rel="stylesheet" type="text/css" />
      """

  Scenario: Writing assets from a mounted app
    Given these files exist
      | input/foo.css |
    And the app is configured as follows
      """ruby
      Pannier.build do
        root   '/assets'
        input  'input'
        output 'output'

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
      <link href="/assets/foo.css" rel="stylesheet" type="text/css" />
      """

    Scenario: Writing assets in development mode
      Given these files exist
        | input/a.css |
        | input/b.css |
      And the app is configured as follows
        """ruby
        Pannier.build('development') do
          input  'input'
          output 'output'

          package :foo do
            assets '*.css'
            host('production') { concat 'foo.min.css' }
          end
        end
        """
      And an asset writer for the app has been instantiated
      When I use the asset writer as follows
        """ruby
        @writer.write(:css, :foo)
        """
      Then the following HTML should be written to the page
        """html
        <link href="/a.css" rel="stylesheet" type="text/css" />
        <link href="/b.css" rel="stylesheet" type="text/css" />
        """
