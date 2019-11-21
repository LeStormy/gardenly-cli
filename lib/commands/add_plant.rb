require 'json'

module Commands
  class AddPlant
    attr_accessor :app, :environment

    def initialize(args)
      @app, @environment = args
    end

    def execute
      puts "Adding a new Plant..."
      user_input

      # pp @payload

     
      run "#{ssh_command} -t '#{remote_command}'"
    end

    private

    def user_input
      @payload = {}
      print "Name: "
      $stdout.flush
      @payload[:name] = STDIN.gets.chomp 

      print "Hauteur a maturite (format [min]-[max]): "
      $stdout.flush
      @payload[:height] = STDIN.gets.chomp 

      print "Mois de debut de floraison (numerique): "
      $stdout.flush
      @payload[:blossoming_start] = STDIN.gets.chomp 

      print "Mois de fin de floraison (numerique): "
      $stdout.flush
      @payload[:blossoming_end] = STDIN.gets.chomp 

      print "Type de plante (Arbre, Fleur, Legume, Arbuste): "
      $stdout.flush
      @payload[:type] = STDIN.gets.chomp 

      print "Forme (Arrondi, Buissonant, Tombant, Tapis) (format [arg1-arg2, ...]): "
      $stdout.flush
      @payload[:shapes] = STDIN.gets.chomp 

      print "Types de sols (Calcaire, Sableux, Humus) (format [arg1-arg2, ...]): "
      $stdout.flush
      @payload[:grounds] = STDIN.gets.chomp

      print "Fourchette de pH (format [max-min]): "
      $stdout.flush
      @payload[:ph] = STDIN.gets.chomp 

      print "Rusticite: "
      $stdout.flush
      @payload[:rusticity] = STDIN.gets.chomp 

      print "Besoin en eau: "
      $stdout.flush
      @payload[:water_need] = STDIN.gets.chomp 

      print "Besoin en soleil: "
      $stdout.flush
      @payload[:sun_need] = STDIN.gets.chomp 

      print "Couleurs (format [arg1-arg2, ...]): "
      $stdout.flush
      @payload[:colors] = STDIN.gets.chomp 

      print "Periodicite (Vivace, Anuelle, Bisannuelle) (format [arg1-arg2]): "
      $stdout.flush
      @payload[:periodicities] = STDIN.gets.chomp 

      print "Description: "
      $stdout.flush
      @payload[:description] = STDIN.gets.chomp 

      print "Conseil: "
      $stdout.flush
      @payload[:tips] = STDIN.gets.chomp 

      print "Modele: "
      $stdout.flush
      @payload[:rusticity] = STDIN.gets.chomp.to_i

      print "URL Photo: "
      $stdout.flush
      @payload[:photo_url] = STDIN.gets.chomp 
    end

    def run(command)
      puts "Logging into #{app} on #{environment} environment..."
      puts command
      exec command
    end

    def ssh_command
        "ssh debian@greefine.fr"
    end

    def remote_command
      tmp = ""
      @payload.each do |k, v|
        tmp = tmp + "#{k}KEYVAL#{v}INTERKEY"
      end
      
      "cd /home/debian/gardenly-deployement/backend/ && ./execute.sh bundle exec rake \"plants:add_from_cli['#{tmp.reverse.sub("INTERKEY".reverse, "").reverse}']\""
    end
  end
end