module Credentials
  class BasicAuth

    def initialize(account_type)
      @credentials = fetch(account_type)
    end

    def encoded
      Base64.encode64(@credentials[:username] + ":" + @credentials[:password])
    end

    def to_hash
      @credentials
    end

    private

    def fetch(account_type)
      puts "\nPlease entry your #{account_type} credentials\n-------\n"
      puts "username:"
      username = $stdin.readline.strip
      puts "password:"
      system "stty -echo"
      password = $stdin.readline.strip
      system "stty echo"  
      puts ""
      {:username => username, :password => password}
    end

  end

end
