require 'multi_json'
require 'pannier/report'

module Pannier
  module API
    class Handler

      PATH_PATTERN = /^\/packages(\/(?<package_name>\w+))?/

      def initialize(app)
        @app = app
      end

      def handle?(env)
        env['PATH_INFO'] =~ PATH_PATTERN
      end

      def report_body(env)
        matches = env['PATH_INFO'].match(PATH_PATTERN)
        request = Rack::Request.new(env)
        report  = Report.new(@app, request.base_url)
        report.lookup(matches['package_name'])
      end

      def call(env)
        return error('Not an API request') unless handle?(env)
        body = report_body(env)
        body.nil? ? not_found : ok(body)
      end

      private

        def headers
          {
            'Content-Type' => 'application/json'
          }
        end

        def ok(body)
          [200, headers, [MultiJson.dump(body)]]
        end

        def not_found(message = 'Not found')
          body = {
            'status'  => 404,
            'message' => message
          }
          [404, headers, [MultiJson.dump(body)]]
        end

        def error(message = 'Error')
          body = {
            'status'  => 500,
            'message' => message
          }
          [500, headers, [MultiJson.dump(body)]]
        end

    end
  end
end
