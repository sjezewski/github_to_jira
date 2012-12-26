module JIRA
  class Project
    def initialize(project_id)
      @project_id = project_id
      @context = JIRA::API.new(project_id)
    end

    def create_issue(details)
      context = {
        :title => details["title"]
        :body => details["body"]
        :comments => details["comments"]
        :assignee => details[:assignee]
        :milestone => details["milestone"]
      }

      puts "Stub for creating issue: #{context}"

    end
    
  end
end
