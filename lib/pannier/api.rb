require 'multi_json'
require 'pannier/report'

module Pannier
  module API
    class Handler

      PATH_PATTERN = /^\/packages(\/(?<package_name>\w+))?/

      def initialize(app)
        @app = app
      end

      def handle?(request)
        request.path =~ PATH_PATTERN
      end

      def report_body(request)
        matches = request.path.match(PATH_PATTERN)
        report  = Report.new(@app, request.base_url)
        report.lookup(matches['package_name'])
      end

      def call(env)
        request = Rack::Request.new(env)
        return not_found('Not an API request') unless handle?(request)
        body = report_body(request)
        body.nil? ? not_found : success(body)
      end

      private

        def headers
          {
            'Content-Type' => 'application/json'
          }
        end

        def success(body)
          [200, headers, [MultiJson.dump(body)]]
        end

        def not_found(message = 'Not found')
          [404, headers, [message]]
        end

    end
  end
end
