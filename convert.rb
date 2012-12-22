#!/usr/bin/env ruby

# Inputs
# 
# 
# - github
#   - credentials
#   - project
# - GH user ID -> JIRA user ID map
# - local (dropbox) folder bucket (for markdown images)
# - JIRA
#   - credentials
#   - project ID (shortname)
# 
# 
# 


require_relative 'config'
require 'mechanize'
require 'json'

def display(response)
  puts "---"
  puts response.code
  puts response.header
  puts "---"
  puts response.body
end

def get_creds()
  token = File.read("#{ENV["HOME"]}/.g2j/token")
  return token

  puts "github username:"
  user = gets.chomp
  puts "password:"
  system "stty -echo"
  password = gets.chomp
  system "stty echo"  
  
  Base64.encode64(user + ":" + password)
end

$token = "Basic #{get_creds()}"

def github_api(context, action, params={}, body={})
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


def authorize() 
  # Fuck it
  # I get back an auth token but it doesn't work the way all other scripts seem to use it

  return

  body = {
    "scopes" => ["repo"]
  }

  result = github_api({}, "auth", {}, body)

  display(result)
  data = JSON.parse(result.body)

  $token = data["token"]

  puts "Got token: #{$token}"

end

#def issues(repo, milestone)
#  github_api({}, "issues", {:state => "open"}, {})  
#end


#display(issues("manhattan","4.2"))

#display(github_api("milestones"))

def openMilestones(repo)
  result = github_api({:repo => repo, :org => "moovweb"}, "milestones", {:state => "open"})
  openMilestones = {}
  names = []

  JSON.parse(result.body).each do |milestone|
    openMilestones[milestone["title"]] = milestone
    names << milestone["title"]
  end

  puts names

  openMilestones
end

def openIssuesForMilestone(repo, milestone)
  puts "repo #{repo}, milestone #{milestone}"
  milestones = openMilestones(repo)
  thisMilestone = milestones[milestone]

  puts "No such milestone #{milestone}" if thisMilestone.nil?

  result = github_api({:repo => repo, :org => "moovweb"}, "issues", {:state => "open", :milestone => thisMilestone["number"]})

  puts result.code
  puts result.body
  puts result.header.keys

  pagination = result.header["link"]
  puts pagination

  JSON.parse(result.body)
end

authorize

#puts "Open Milestones"
#milestones = openMilestones("manhattan")
#puts milestones

#puts "Open Issues"

issues = openIssuesForMilestone("manhattan", "4.2")
puts issues.size






