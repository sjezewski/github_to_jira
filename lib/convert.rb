require_relative 'github'
require_relative 'jira'
require 'yaml'

module GithubToJira
  class Converter

    def initialize(config_file)
      @config = YAML.load(File.read(config_file))        
      puts @config
    end

    def convert

      @config[:repo_to_project].each do |gh_repo, jira_repo|
        repo = Github::Repository.new(@config[:github_organization], gh_repo)  

        puts "---"
        puts gh_repo
        puts "---"
        milestones = repo.milestones
        puts "Milestones : \t#{milestones.keys}"

        milestones.each do |name, milestone|
          issues = repo.issues({:milestone => milestone["number"]}) 
          puts "\tMilestone [#{name}] : issue count: #{issues.size}"

          issues.each do |issue|
            number = issue["number"]
            issue = repo.issue(number)
            assignee = issue['assignee'].nil? ? nil : issue['assignee']['login']
            issue[:assignee] = assignee

            puts "\t\tIssue #{number} :: #{assignee} :: #{issue['title']}"
          end
        end
      end

      
    end

  end
end
