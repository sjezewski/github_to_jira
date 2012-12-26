require 'mechanize'
require 'JSON'

module Jira
  class API

    def initialize(jira_root, project_id)
      @jira_root = jira_root
      @project_id = project_id
      authenticate
    end

    def execute(action, params={}, body={})
      m = Mechanize.new()
      action = actions(action)
      url = action[:url]
      puts url
      verb = action[:verb]

      headers = {"Content-Type" => "application/json", "Cookie" => @token}

      puts "Sending: #{verb} : #{url} : #{params} : #{body} : #{headers}"
      
      if verb == :get
        m.get(url, params, nil, headers)
      else
        m.send(verb, url, body.to_json, headers)
      end


    end

    private

    def actions(name)
      root = "https://moovweb.atlassian.net/rest"

      actions = {
        "auth" => {
          :url => "#{root}/auth/1/session",
          :verb => :post
        },
        "projectVersions" => {          
          :url => "#{root}/api/2/project/#{@project_id}/versions",
          :verb => :get
        }
      }

      actions[name]
    end
    
    def credentials
      puts "jira username:"
      user = gets.chomp
      puts "password:"
      system "stty -echo"
      password = gets.chomp
      system "stty echo"  

      {:user => user, :password => password}
    end

    def authenticate
      creds = credentials

      result = execute("auth", {}, creds.to_json)
      puts "JIRA Auth:"
      puts result.code
      puts result.body
      puts result.header

    end

  end
end
