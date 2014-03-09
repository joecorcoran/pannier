require 'logger'

module Pannier
  class Logger < ::Logger

    def initialize(*args)
      super
      @formatter = _formatter
    end

    private

      def _formatter
        proc do |severity, time, progname, msg|
          msg + "\n"
        end
      end

  end
end
