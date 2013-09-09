Feature: Writing assets
  In order to use my assets in a site
  As a developer
  I want to write the HTML that will include my assets on the page

  Scenario: Writing JavaScript assets
    Given these files exist
      | fixtures/source/one.js |
      | fixtures/source/two.js |
    And the app is configured as follows
      """ruby
      Pannier.build do
        source 'fixtures/source'
        result 'fixtures/result'

        package :scripts do
          assets '*.js'
        end
      end
      """
    And the app has been processed
    When I use the writer as follows
      """ruby
      @app.writer.write(:js, :scripts, :defer => 'defer')
      """
    Then the following HTML should be written to the page
     """html
     <script type="text/javascript" src="/one.js" defer="defer"></script>
     <script type="text/javascript" src="/two.js" defer="defer"></script>
     """

  Scenario: Writing CSS assets
    Given these files exist
      | fixtures/source/one.css |
      | fixtures/source/two.css |
    And the app is configured as follows
      """ruby
      Pannier.build do
        source 'fixtures/source'
        result 'fixtures/result'

        package :styles do
          assets '*.css'
        end
      end
      """
    And the app has been processed
    When I use the writer as follows
      """ruby
      @app.writer.write(:css, :styles, :media => 'screen')
      """
    Then the following HTML should be written to the page
      """html
      <link rel="stylesheet" type="text/css" href="/one.css" media="screen" />
      <link rel="stylesheet" type="text/css" href="/two.css" media="screen" />
      """
