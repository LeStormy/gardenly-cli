require 'json'

module Commands
  class UpdatePlant
    attr_accessor :app, :environment

    def initialize(args)
      @app, @environment = args
    end

    def execute
      puts "Updateing an existing Plant..."
      get_plant
      user_input

      pp @payload

      run "#{ssh_command} -t '#{remote_command}'"
    end

    private

    def get_plant
      print "Name of the plant to update: "
      $stdout.flush
      @plant = STDIN.gets.chomp

      puts "Mettre a jour... [arg1,arg2, ...]"
      puts "1) Nom\n2) Hauteur a maturite\n3) Floraison\n4) Type\n5) Forme\n6) Sols\n7) pH\n8) Rusticite\n9) Besoin en eau\n10) Besoin en soleil\n11) Couleur(s)\n12) Periodicites\n13) Description\n14) Conseils\n15) Modele\n16) URL Photo"
      @fields = STDIN.gets.chomp.split(",")
      puts "\n"
    end

    def user_input
      puts "Nouvelles valeurs..."
      @payload = {}

      if (@fields.include?("1"))
        print "Name: "
        $stdout.flush
        @payload[:name] = STDIN.gets.chomp 
      end

      if (@fields.include?("2"))
        print "Hauteur a maturite (format [min] - [max]): "
        $stdout.flush
        @payload[:height] = STDIN.gets.chomp 
      end

      if (@fields.include?("3"))
        print "Mois de debut de floraison (numerique): "
        $stdout.flush
        @payload[:blossoming_start] = STDIN.gets.chomp 
      end

      if (@fields.include?("3"))
        print "Mois de fin de floraison (numerique): "
        $stdout.flush
        @payload[:blossoming_end] = STDIN.gets.chomp 
      end

      if (@fields.include?("4"))
        print "Type de plante (Arbre, Fleur, Legume, Arbuste): "
        $stdout.flush
        @payload[:type] = STDIN.gets.chomp 
      end

      if (@fields.include?("5"))
        print "Forme (Arrondi, Buissonant, Tombant, Tapis) (format [arg1, arg2, ...]): "
        $stdout.flush
        @payload[:shapes] = STDIN.gets.chomp 
      end

      if (@fields.include?("6"))
        print "Types de sols (Calcaire, Sableux, Humus) (format [arg1, arg2, ...]): "
        $stdout.flush
        @payload[:grounds] = STDIN.gets.chomp
      end

      if (@fields.include?("7"))
        print "Fourchette de pH (format [max, min]): "
        $stdout.flush
        @payload[:ph] = STDIN.gets.chomp 
      end

      if (@fields.include?("8"))
        print "Rusticite: "
        $stdout.flush
        @payload[:rusticity] = STDIN.gets.chomp 
      end

      if (@fields.include?("9"))
        print "Besoin en eau: "
        $stdout.flush
        @payload[:water_need] = STDIN.gets.chomp 
      end

      if (@fields.include?("10"))
        print "Besoin en soleil: "
        $stdout.flush
        @payload[:sun_need] = STDIN.gets.chomp 
      end

      if (@fields.include?("11"))
        print "Couleurs (format [arg1, arg2, ...]): "
        $stdout.flush
        @payload[:colors] = STDIN.gets.chomp 
      end

      if (@fields.include?("12"))
        print "Periodicite (Vivace, Anuelle, Bisannuelle) (format [arg1, arg2]): "
        $stdout.flush
        @payload[:periodicities] = STDIN.gets.chomp 
      end

      if (@fields.include?("13"))
        print "Description: "
        $stdout.flush
        @payload[:description] = STDIN.gets.chomp 
      end

      if (@fields.include?("14"))
        print "Conseil: "
        $stdout.flush
        @payload[:tips] = STDIN.gets.chomp 
      end

      if (@fields.include?("15"))
        print "Modele: "
        $stdout.flush
        @payload[:rusticity] = STDIN.gets.chomp.to_i
      end

      if (@fields.include?("16"))
        print "URL Photo: "
        $stdout.flush
        @payload[:photo_url] = STDIN.gets.chomp 
      end
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
      puts @fields
      "cd /home/debian/gardenly-deployement/backend/ && ./execute.sh bundle exec rake \"plants:update_from_cli[#{@plant},'#{@fields.to_s.gsub("[", "").gsub("]", "").gsub("\"", "").gsub(", ", "-")}','#{tmp.reverse.sub("INTERKEY".reverse, "").reverse}']\""
    end
  end
end