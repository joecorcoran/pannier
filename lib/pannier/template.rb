module Pannier
  module Template

    module Helpers
      def attr_string(hash)
        pairs = hash.reduce([]) do |arr, pair|
          arr << "#{pair[0].to_s}=\"#{pair[1]}\""
        end
        pairs.join(' ')
      end
    end

    class Javascript
      include Helpers

      def call(path, attrs)
        defaults = {
          'type' => 'text/javascript',
          'src'  => path
        }
        "<script #{attr_string(defaults.merge(attrs))}></script>"
      end
    end

    class CSS
      include Helpers
      
      def call(path, attrs)
        defaults = {
          'rel'  => 'stylesheet',
          'type' => 'text/css',
          'href' => path
        }
        "<link #{attr_string(defaults.merge(attrs))} />"
      end
    end

  end
end
