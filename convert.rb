#!/usr/bin/env ruby

require_relative 'github'
require 'yaml'

#puts "Open Milestones"
#milestones = openMilestones("manhattan")
#puts milestones

#puts "Open Issues"

#issues = openIssuesForMilestone("manhattan", "4.2")
#puts issues.size

config_file = ARGV[0] == nil ? "config/example.yml" : ARGV[0]

config = YAML.load(File.read(config_file))

puts config


config[:github_repos].each do |gh_repo|
  repo = Github::Repository.new(config[:organization], gh_repo)  

  puts "---"
  puts gh_repo
  puts "---"
  milestones = repo.milestones
  puts milestones

#  issues = repo.issues({:milestone => milestones["4.2"]["number"]})

  puts "Hit any key to continue"
  gets.chomp
end





