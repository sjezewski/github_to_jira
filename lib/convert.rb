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

      @config[:repo_to_project].each do |gh_repo, jira_proj|
        source = Github::Repository.new(@config[:github_organization], gh_repo)  

        puts "---"
        puts gh_repo
        puts "---"
        milestones = source.milestones
        puts "Milestones : \t#{milestones.keys}"

        
        destination = Jira::Project.new(@config[:jira_root], jira_proj)
        mismatched_milestones = false

        source.milestones.keys.each do |name|
          if destination.versions[name].nil?
            next if name == "none"
            mismatched_milestones = true 
            puts "Milestone #{name} exists on github(#{gh_repo}) but not on jira(#{jira_proj})"
          end
        end

        if mismatched_milestones == true
          puts "Invalid destination setup. Milestones must be 1-1"
          exit 1
        end

        milestones.each do |name, milestone|
          issues = source.issues({:milestone => milestone["number"]}) 
          puts "\tMilestone [#{name}] : issue count: #{issues.size}"

          issues.each do |issue|
            number = issue["number"]
            issue = source.issue(number)
            assignee = issue['assignee'].nil? ? nil : issue['assignee']['login']
            unless assignee.nil?
              assignee = @config[:user_id][assignee]
              if assignee.nil?
                puts "Error: Github user #{assignee} is missing a corresponding JIRA username"
                exit 1
              end
            end
            issue['assignee'] = assignee
            issue['milestone']['name'] = name

            response = destination.create_issue(issue)
            
            puts "\t\tGihub Issue #{number} :: #{assignee} :: #{issue['title']} --> JIRA Issue #{response['key']}"
          end
        end
      end

      
    end

  end
end
