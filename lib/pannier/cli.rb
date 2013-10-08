require 'slop'

module Pannier
  class CLI
    def initialize(args, stdin = $stdin, stdout = $stdout, stderr = $stderr)
      @args, @stdin, @stdout, @stderr = args, stdin, stdout, stderr
    end

    def run!
      command, opts = (@args.shift || 'usage').to_sym, @args
      public_send(command, *opts)
    end

    def process(*opts)
      opts = Slop.parse(opts, :help => true) do
        banner 'Usage: pannier process [options]'
        on :c, :config,      'Config file',      :argument => :optional, :default => '.assets.rb'
        on :e, :environment, 'Host environment', :argument => :optional, :default => 'development'
        on :a, :assets,      'Asset paths',      :argument => :optional, :as => Array
      end

      config_path = File.expand_path(opts[:config])
      err(no_config_msg(config_path)) && abort unless File.exists?(config_path)

      app = Pannier.build_from(config_path, opts[:environment])

      if opts.assets?
        paths = opts[:assets].map { |path| File.expand_path(path) }
        app.process_owners!(*paths)
      else
        app.process!
      end
      exit
    end

    def usage
      out(usage_msg)
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

      def no_config_msg(path)
        <<-txt
        Pannier config file not found at #{path}.
        txt
      end

      def usage_msg
        <<-txt
        Available commands (run any command with --help for details):
            pannier process        Process assets
            pannier usage          Show this list of commands
        txt
      end

      def out(*msgs)
        msg = msgs.map { |m| format_output(m) }.join
        @stdout.puts(msg)
      end

      def err(*msgs)
        msg = msgs.map { |m| format_output(m) }.join
        msg += format_output(usage_msg)
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
