require_relative 'config'
require 'mechanize'
require 'json'


module Github

  class API

    class << self

      $root = "https://api.github.com"

      $github_api_config = {
        "auth" => {
          :url => "#{$root}/authorizations",
          :verb => :post
        },
        "issues" => {
          #    :url => "https://api.github.com/repos/moovweb/manhattan/issues",
          :url => "#{$root}/repos/moovweb/manhattan/issues",
          :verb => :get
        },
        "milestones" => {
          :url => "#{$root}/repos/moovweb/<%=context[:repo]%>/milestones",
          :verb => :get
        },
        "issues" => {
          :url => "#{$root}/repos/moovweb/<%=context[:repo]%>/issues",
          :verb => :get
        }
      }

      def api_url(action, context={})
        action = $github_api_config[action]

        url_template = ERB.new(action[:url])
        action[:url] = url_template.result(binding)

        action
      end


      def authenticate()
        token = File.read("#{ENV["HOME"]}/.g2j/token")
        return token

        #TODO: Hook this back in if the token isn't found

        puts "github username:"
        user = gets.chomp
        puts "password:"
        system "stty -echo"
        password = gets.chomp
        system "stty echo"  
        
        Base64.encode64(user + ":" + password)
      end

      def execute(context, action, params={}, body={})
        m = Mechanize.new()
        method = github_api_method(action, context)
        url = method[:url]
        puts url
        verb = method[:verb]

        headers = {"Content-Type" => "application/json", "Authorization" => $token}

        puts "Sending: #{verb} : #{url} : #{params} : #{body} : #{headers}"
        
        if verb == :get
          m.get(url, params, nil, headers)
        else
          m.send(verb, url, body.to_json, headers)
        end


      end


    end

  end

end
