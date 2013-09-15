Feature: Conditional processing per host environment
  In order to process assets according to the environment of the host app
  As a developer
  I want to specify this in my package definitions

  Scenario: Assets are processed based on host environment
    Given these files exist
      | fixtures/input/bar.js |
      | fixtures/input/baz.js |
    And the app is configured as follows
      """ruby
      Pannier.build('production') do
        input  'fixtures/input'
        output 'fixtures/output'

        package :foo do
          host 'development' do
            modify do |_, basename|
              ['/* development */', basename]
            end
          end
          host 'production' do
            concat 'foo.js'
          end
        end
      end
      """
      And the app has been processed
      Then the file "fixtures/output/foo.js" should not include
        """javascript
        /* development */
        """
