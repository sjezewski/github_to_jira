require_relative 'config'
require 'mechanize'
require 'json'


module Github

  class API

    def initialize(org, repo)
      authenticate()      

      @org = org
      @repo = repo

      @root = "https://api.github.com"

      @actions = {
        "auth" => {
          :url => "#{@root}/authorizations",
          :verb => :post
        },
        "issues" => {
          :url => "#{@root}/repos/#{@org}/#{@repo}/issues",
          :verb => :get
        },
        "milestones" => {
          :url => "#{@root}/repos/#{@org}/#{@repo}/milestones",
          :verb => :get
        },
        "issues" => {
          :url => "#{@root}/repos/#{@org}/#{@repo}/issues",
          :verb => :get
        }
      }
    end

    def execute(action, params={}, body={})

      m = Mechanize.new()
      action = @actions[action]
      url = action[:url]
      puts url
      verb = action[:verb]

      headers = {"Content-Type" => "application/json", "Authorization" => @token}

      puts "Sending: #{verb} : #{url} : #{params} : #{body} : #{headers}"
      
      if verb == :get
        m.get(url, params, nil, headers)
      else
        m.send(verb, url, body.to_json, headers)
      end


    end

    private

    def authenticate()
      @token = "Basic " + File.read("#{ENV["HOME"]}/.g2j/token")
      return

      #TODO: Hook this back in if the token isn't found

      puts "github username:"
      user = gets.chomp
      puts "password:"
      system "stty -echo"
      password = gets.chomp
      system "stty echo"  
      
      Base64.encode64(user + ":" + password)
    end

  end

end
