module Pannier
  class CLI
    def initialize(args, stdin = $stdin, stdout = $stdout, stderr = $stderr)
      @args, @stdin, @stdout, @stderr = args, stdin, stdout, stderr
    end

    def run!
      command, command_args = (@args.shift || 'help').to_sym, @args
      public_send(command, *command_args)
    end

    def process(host_env = nil, path = 'Pannierfile')
      config_path = File.expand_path(path)
      unless File.exists?(config_path)
        err(<<-txt)

        Pannier config file not found at #{config_path}.
        txt
        abort
      end

      app = Pannier.build_from(path, host_env)
      app.process!
      exit
    end

    def help
      out(help_msg)
      exit
    end

    def method_missing(command, *args)
      err(<<-txt)

      You ran `pannier #{command}#{(' ' + args.join(' ')) unless args.empty?}`.
      Pannier has no command named "#{command}".
      txt
      exit(127)
    end

    private

      def help_msg
        <<-txt

        Usage instructions:
        
        pannier process [host_env] [path]  # Process assets
                                           #
                                           # [host_env]  (Default is nil)
                                           #             The host application environment
                                           #             e.g. development or production.
                                           #
                                           # [path]      (Default is ./Pannierfile)
                                           #             The path to your config file.
                                           #
        pannier help                       # Display usage instructions

        txt
      end

      def out(*msgs)
        msg = msgs.map { |m| format_output(m) }.join
        @stdout.puts(msg)
      end

      def err(*msgs)
        msg = msgs.map { |m| format_output(m) }.join
        msg += format_output(help_msg)
        @stderr.puts(msg)
      end
    
      def format_output(txt)
        spaces = '^[ \t]'
        indent = txt.scan(/#{spaces}*(?=\S)/).min
        indent_size = indent ? indent.size : 0
        txt.gsub(/#{spaces}{#{indent_size}}/, '')
      end
  end
end
