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
    And an asset writer for the app exists
    When I use the writer as follows
      """ruby
      @writer.write(:js, :scripts)
      """
    Then the following HTML should be written to the page
     """html
     <script type="text/javascript" src="/one.js"></script>
     <script type="text/javascript" src="/two.js"></script>
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
    And an asset writer for the app exists
    When I use the writer as follows
      """ruby
      @writer.write(:css, :styles)
      """
    Then the following HTML should be written to the page
      """html
      <link rel="stylesheet" type="text/css" href="/one.css" />
      <link rel="stylesheet" type="text/css" href="/two.css" />
      """
