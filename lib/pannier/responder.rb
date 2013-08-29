module Pannier
  class Responder

    def initialize(manifest)
      @manifest = manifest
    end

    def response(request)
      case request.path
      when /^\/manifest/
        json_response(@manifest)
      else
        not_found
      end
    end

    private

      def json_response(content)
        [200, { 'Content-Type' => 'application/json' }, [content.to_json]]
      end

      def not_found
        [404, { 'Content-Type' => 'text/plain' }, ['Not found']]
      end

  end
end
