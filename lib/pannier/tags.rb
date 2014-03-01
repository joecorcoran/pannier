require 'erb'

module Pannier
  class Tags

    attr_reader :app

    def initialize(app)
      @app = app
    end

    def write(package_name, attrs = {})
      template_klass = attrs.delete(:as)
      template = template_klass.new
      to_write = @app[package_name].output_assets.map do |asset|
        template.call(asset.serve_from(@app), attrs)
      end
      to_write.join("\n")
    end

    module Helpers
      def attrs_to_s(hash)
        pairs = hash.reduce([]) do |arr, pair|
          key, value = escape(pair[0].to_s), escape(pair[1].to_s)
          arr << "#{key}=\"#{value}\""
        end
        pairs.sort.join(' ')
      end

      def escape(string)
        ERB::Util.html_escape(string)
      end
    end

    class JavaScript
      include Helpers

      def call(path, attrs)
        attrs = attrs_to_s({
          :type => 'text/javascript',
          :src  => path
        }.merge(attrs))
        
        template.result(binding)
      end

      def template
        ERB.new(<<-erb.strip)
          <script <%= attrs %>></script>
        erb
      end
    end

    class CSS
      include Helpers
      
      def call(path, attrs)
        attrs = attrs_to_s({
          :rel  => 'stylesheet',
          :type => 'text/css',
          :href => path
        }.merge(attrs))

        template.result(binding)
      end

      def template
        ERB.new(<<-erb.strip)
          <link <%= attrs %> />
        erb
      end
    end

  end
end
