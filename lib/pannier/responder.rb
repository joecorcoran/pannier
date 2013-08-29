module Pannier
  class Responder

    def initialize(manifest)
      @manifest = manifest
    end

    def response(request)
      matches = request.path.match(/^\/packages(\/(?<name>\w+))?(\/(?<state>\w+))?/)
      return respond_api(matches['name'], matches['state']) if matches.length > 0
      respond_not_found
    end

    private

      def respond_api(name, state)
        content = (name || state) ? @manifest.package_details(name, state) : @manifest.tree
        return respond_not_found if content.nil?
        respond_json(content)
      end

      def respond_json(content)
        [200, { 'Content-Type' => 'application/json' }, [MultiJson.dump(content)]]
      end

      def respond_not_found(msg = 'Not found')
        [404, { 'Content-Type' => 'text/plain' }, [msg]]
      end

      def respond_error(msg = 'Application error')
        [500, { 'Content-Type' => 'text/plain' }, [msg]]
      end

  end
end
