module Commands
    class Console < Commands::Base
      def remote_command
        "cd /home/debian/gardenly-deployement/backend/ && ./execute.sh bundle exec rails c"
      end
    end
  end