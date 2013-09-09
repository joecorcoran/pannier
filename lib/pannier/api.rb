module Pannier
  module API

    REQUEST_PATTERN = /^\/packages(\/(?<name>\w+))?(\/(?<state>\w+))?/

    def self.handles?(request)
      request.path =~ REQUEST_PATTERN
    end

    class Response

      def initialize(request, app)
        @request, @app = request, app
        manifest = Manifest.new(app).build!(request.env)
        pkg = @request.path.match(REQUEST_PATTERN)
        @content = manifest.package_details(pkg['name'], pkg['state'])
      end

      def headers
        { 'Content-Type' => 'application/json' }
      end

      def content
        MultiJson.dump(@content)
      end

      def success
        [200, headers, [content]]
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
