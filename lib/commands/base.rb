module Commands
  class Base
    attr_accessor :app, :environment

    def initialize(args)
      @app, @environment = args
    end

    def execute
      run "#{ssh_command} -t '#{remote_command}'"
    end

    private

    def run(command)
      puts "Logging into MPP on production environment..."
      puts command
      exec command
    end

    def ssh_command
        "ssh debian@greefine.fr"
    end

    def remote_command
      raise NotImplementedError
    end
  end
end