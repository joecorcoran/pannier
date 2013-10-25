Feature: Writing assets
  In order to use my assets in a site
  As a developer
  I want to write the HTML that will include my assets on the page

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

  Scenario: Writing assets from a mounted app in production
    Given these files exist
      | input/styles/foo.css |
    And the file ".assets.rb" contains
      """ruby
      root   '/assets'
      
      input  'input'
      output 'output'

      package :styles do
        input  'styles'
        assets 'foo.css'
      end
      """
    And the app is loaded in a production environment
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
        | input/styles/a.css |
        | input/styles/b.css |
      And the file ".assets.rb" contains
        """ruby
        input  'input'
        output 'output'

        package :foo do
          input  'styles'
          assets '*.css'
          host 'production' do
            concat 'foo.min.css'
          end
        end
        """
      And the app is loaded
      And an asset writer for the app has been instantiated
      When I use the asset writer as follows
        """ruby
        @writer.write(:css, :foo)
        """
      Then the following HTML should be written to the page
        """html
        <link href="/styles/a.css" rel="stylesheet" type="text/css" />
        <link href="/styles/b.css" rel="stylesheet" type="text/css" />
        """
