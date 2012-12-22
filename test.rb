#!/usr/bin/env ruby

require_relative 'config'
require 'mechanize'

m = Mechanize.new()

body = {
  "client_id" => $oauth["client_id"],
  "client_secret" => $oauth["client_secret"],
  "scopes" => ["repo"]
}

url = $github_api["auth"]
result = m.post(url, body, {"Content-Type" => "application/json"})

puts url
puts "---"
puts result.code
puts result.header
puts "---"
puts result.body



