#!/usr/bin/env ruby

require_relative 'github'


#puts "Open Milestones"
#milestones = openMilestones("manhattan")
#puts milestones

#puts "Open Issues"

#issues = openIssuesForMilestone("manhattan", "4.2")
#puts issues.size


repo = Github::Repository.new("moovweb", "manhattan")

milestones = repo.milestones
puts milestones

issues = repo.issues({:milestone => milestones["4.2"]["number"]})
