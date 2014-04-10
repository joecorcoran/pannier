module Pannier
  class Logger
    class PackageLogger

      def initialize(logger, package)
        @logger, @package = logger, package
      end

      def wrap(&block)
        log_input!
        block.call
        log_output!
      end

      def log!(messages, indent = 0)
        return unless @logger
        Array(messages).each do |msg|
          indent.times { msg.prepend(' ') }
          @logger.info(msg)
        end
      end

      def log_input!
        log!("Package #{@package.name.inspect}")
        log!('Input ->', 2)
        log!(@package.input_assets.map(&:path), 4)
      end

      def log_output!
        log!('Output ->', 2)
        log!(@package.output_assets.map(&:path), 4)
      end

    end
  end
end
