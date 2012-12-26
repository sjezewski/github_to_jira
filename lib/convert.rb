#!/usr/bin/env ruby

require_relative 'github'
require 'yaml'

module GithubToJira
  class Converter
    class << self

      def initialize(config_file)
        @config = YAML.load(File.read(config_file))        
        puts @config
        @jira_context = JIRA::API.new
      end

      def convert

        config[:github_repos].each do |gh_repo|
          repo = Github::Repository.new(config[:organization], gh_repo)  

          puts "---"
          puts gh_repo
          puts "---"
          milestones = repo.milestones
          puts milestones

          milestones.each do |name, milestone|
            puts "     "
            puts " --- "
            puts "Milestone [#{name}]:"
            issues = repo.issues({:milestone => milestone["number"]}) 
            puts "issue count: #{issues.size}"

            issues.each do |issue|
              number = issue["number"]
              issue = repo.issue(number)
              assignee = issue['assignee'].nil? ? nil : issue['assignee']['login']
              issue[:assignee] = assignee

              puts "Issue #{number} :: #{assignee} :: #{issue['title']}"
            end
          end
        end

        
      end

    end
  end
end


if $__PROGRAM_NAME__ == ARGC
  config_file = ARGV[0] == nil ? "config/example.yml" : ARGV[0]
end
