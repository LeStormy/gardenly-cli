module Commands
    class Logs < Commands::Base
      def remote_command
        "cd gardenly-deployement/backend/gardenly-back/log && tail -f *.log"
      end
    end
  end