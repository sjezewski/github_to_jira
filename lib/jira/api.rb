require 'mechanize'
require 'JSON'

module Jira
  class API

    def initialize(jira_root, project_id, creds)
      @jira_root = jira_root
      @project_id = project_id
      @creds = creds.to_hash
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
        begin
          m.send(verb, url, body.to_json, headers)
        rescue Net::HTTP::Persistent::Error => e
          error = "Persistent Network Error : #{e} : This can happen if the request body is too big. This request body was #{body.to_json.size} bytes"
          return {'status' => 500, 'error' => error}
        rescue Mechanize::ResponseCodeError => e
          puts "Error Response"
          puts "====="
          puts e.page.body
          exit 1
        end
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

    def authenticate      
      result = execute("auth", {}, @creds)
      cookies = result.header['set-cookie']
      cookies =~ /(studio\.crowd\.tokenkey=[^"]+?);/
      @token = $1
    end

  end
end
