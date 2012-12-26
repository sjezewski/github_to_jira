#!/usr/bin/env ruby
require 'yaml'
require_relative "../lib/jira"

config_file = ARGV[0] == nil ? "config/example.yml" : ARGV[0]
config = YAML.load(File.read(config_file))        


jproj = Jira::Project.new(config[:jira_root], "GITT")


issue = {

}

jproj.create_issue(issue)
