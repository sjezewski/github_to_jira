require_relative 'api'

module Jira
  class Project
    def initialize(jira_root, project_id)
      @project_id = project_id
      @context = Jira::API.new(jira_root, project_id)
    end

    def create_issue(details)
      context = {
        :title => details["title"],
        :body => details["body"],
        :comments => details["comments"],
        :assignee => details[:assignee],
        :milestone => details["milestone"]
      }

      puts "Stub for creating issue: #{context}"

    end
    
  end
end
