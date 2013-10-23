Feature: Rack middleware
  In order to modify asset responses
  As a developer
  I want to serve my assets via Rack middleware

  Scenario: Middleware is set per package
    Given these files exist
      | input/foo.css |
      | input/bar.js  |
    And a loaded ruby file contains
      """ruby
      class Speaker
        def initialize(app, message)
          @app, @message = app, message
        end

        def call(env)
          status, headers, response = @app.call(env)
          headers['X-Says'] = @message
          [status, headers, response]
        end
      end
      """
    And the file ".assets.rb" contains
      """ruby
      input  'input'
      output 'output'

      package :styles do
        assets 'foo.css'
        use Rack::Deflater
      end
      package :scripts do
        assets 'bar.js'
        use Speaker, 'hello'
      end
      """
    And the app is loaded
    And the app has been processed

    When I request "/foo.css" with these headers
      | Accept-Encoding  | gzip  |
    Then the response status should be 200
    Then I should see these headers
      | Content-Encoding | gzip  |
    And I should not see these headers
      | X-Says |

    And when I request "/bar.js"
    Then the response status should be 200
    Then I should see these headers
      | X-Says           | hello |
    And I should not see these headers
      | Content-Encoding |
