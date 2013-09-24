module Pannier
  class CLI
    def initialize(args, stdin = $stdin, stdout = $stdout, stderr = $stderr, kernel = Kernel)
      @args, @stdin, @stdout, @stderr, @kernel = args, stdin, stdout, stderr, kernel
    end

    def execute!
      command, command_args = (@args.shift || 'help').to_sym, @args
      public_send(command, *command_args)
    end

    def process(host_env = nil, path = 'Pannierfile')
      config_path = File.expand_path(path)
      unless File.exists?(config_path)
        output(format(no_config_msg(config_path)) + format(help_msg))
        @kernel.exit(1) and return
      end

      app = Pannier.build_from(path, host_env)
      app.process!
      @kernel.exit(0)
    end

    def help
      output(format(help_msg))
      @kernel.exit(0)
    end

    def method_missing(command, *args)
      msg = <<-text

      You ran `pannier #{command}#{(' ' + args.join(' ')) unless args.empty?}`.
      Pannier has no command named "#{command}".
      text
      output(format(msg) + format(help_msg))
      @kernel.exit(127)
    end

    private

      def no_config_msg(config_path)
        <<-text

        Pannier config file not found at #{config_path}.
        text
      end

      def help_msg
        <<-text

        Usage instructions:
        
        pannier process [host_env] [path]   # Process assets
                                            # [host_env]
                                            #   Optional, default is nil
                                            #   The host application environment in which to process
                                            #   your assets, e.g. development or production.
                                            # [path]
                                            #   Optional, default is ./Pannierfile
                                            #   The path to your config file.
        
        pannier help                        # Display usage instructions

        text
      end

      def output(message)
        @stdout.puts(message)
      end
    
      def format(text)
        spaces = '^[ \t]'
        indent = text.scan(/#{spaces}*(?=\S)/).min
        indent_size = indent ? indent.size : 0
        text.gsub(/#{spaces}{#{indent_size}}/, '')
      end
  end
end
