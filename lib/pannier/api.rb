require 'multi_json'
require 'pannier/report'

module Pannier
  module API

    REQUEST_PATTERN = /^\/packages(\/(?<package_name>\w+))?/

    def self.handles?(request)
      request.path =~ REQUEST_PATTERN
    end

    class Response

      def initialize(request, app)
        @request, @app = request, app
        report = Report.new(app, request.base_url)
        matches = @request.path.match(REQUEST_PATTERN)
        @content = report.lookup(matches['package_name'])
      end

      def headers
        { 'Content-Type' => 'application/json' }
      end

      def body
        MultiJson.dump(@content)
      end

      def success
        [200, headers, [body]]
      end

      def not_found(message = 'Not found')
        [404, headers, [message]]
      end

      def response
        @content.nil? ? not_found : success
      end

    end
  end
end
