require 'mechanize'
require 'JSON'

module Jira
  class API

    def initialize(jira_root, project_id)
      @jira_root = jira_root
      @project_id = project_id
      authenticate
      @debug = false
    end

    def execute(action, params={}, body={})
      m = Mechanize.new()
      action = actions(action)
      url = action[:url]
      puts url if @debug
      verb = action[:verb]

      headers = {"Content-Type" => "application/json", "Cookie" => @token}

      puts "Sending: #{verb} : #{url} : #{params} : #{body} : #{headers}" if @debug
      
      if verb == :get
        m.get(url, params, nil, headers)
      else
        m.send(verb, url, body.to_json, headers)
      end


    end

    private

    def actions(name)

      actions = {
        "auth" => {
          :url => "#{@jira_root}/auth/1/session",
          :verb => :post
        },
        "projectVersions" => {          
          :url => "#{@jira_root}/api/2/project/#{@project_id}/versions",
          :verb => :get
        },
        "meta" => {          
          :url => "#{@jira_root}/api/2/issue/createmeta",
          :verb => :get
        },
        "issue" => {          
          :url => "#{@jira_root}/api/2/issue",
          :verb => :post
        }
      }

      actions[name]
    end
    
    def credentials
      puts "jira username:"
      user = $stdin.readline.strip
      puts "password:"
      system "stty -echo"
      password = $stdin.readline.strip
      system "stty echo"  

      {:username => user, :password => password}
    end

    def authenticate
      creds = credentials

      result = execute("auth", {}, creds)
      cookies = result.header['set-cookie']
      cookies =~ /(studio\.crowd\.tokenkey=[^"]+?);/
      @token = $1

    end

  end
end
