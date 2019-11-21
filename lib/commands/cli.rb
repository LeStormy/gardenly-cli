require 'io/console'

module Commands
  class Cli
    attr_accessor :app, :environment

    def initialize(args)
      @app, @environment = args
    end

    def execute
      @running = true
      # if !login
      #   return 
      # end
      user_input
      run @command unless !@running
    end

    private

    def login
      puts "Welcome to Gardenly Admin\nPlease Log In"
      print "Username: "
      $stdout.flush
      @username = STDIN.gets.chomp
      print "Password: ".chomp
      $stdout.flush
      @password = STDIN.noecho(&:gets).chomp
      puts "\n\n"
      if (@username == "test" && @password == "123456")
        true
      else
        false
      end
    end

    def user_input
      puts "Choose an option\n"
      puts "1) Logs\n2) Rails Console\n3) Add Plant\n4) Update Plant\n5) Exit"
      @command = STDIN.gets.chomp 
      puts "\n"
    end

    def run(command)
      case @command
      when "1"
        Commands::Logs.new(nil).execute
      when "2"
        Commands::Console.new(nil).execute
      when "3"
        Commands::AddPlant.new(nil).execute
      when "4"
        Commands::UpdatePlant.new(nil).execute
      when "5"
        @running = false
      end

    end

    def ssh_command
        "ssh debian@greefine.fr"
    end

    def remote_command
      "echo #{@name}"
    end
  end
end