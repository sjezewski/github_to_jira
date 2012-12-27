require_relative 'api'

module Jira
  class Project
    attr_accessor :versions

    def initialize(jira_root, project_id)
      @project_id = project_id
      @context = Jira::API.new(jira_root, project_id)
      @versions = {}
      gather_meta()
    end

    def create_issue(details)

      body = {
        :fields => {
          :project => { :key => @project_id},
          :summary => details["title"],
          :description => details["body"],          
          :issuetype => {:name => "Bug"},
          :assignee => {:name => "sean.jezewski" },
        }
      }

      if details["milestone"] != "none"
        body[:fields][:fixVersions] = [{:name => details["milestone"]}]
      end

      result = @context.execute("issue", {}, body)

      puts "Issue result! #{result.code}\n\n#{result.body}"

    end

    private

    def gather_meta()
      # - Gather meta data which specifies what we can do where
      # - In particular, we care about the 'fixVersions' that are available to us for this project
      # - These need to line up w the github milestones

      result = @context.execute("meta",{:expand => "projects.issuetypes.fields"})
      data = JSON.parse(result.body)

      project = data["projects"].find {|p| p["key"] == @project_id}
      bug = project["issuetypes"].find {|i| i["name"] == "Bug"}
      #puts "BUG=#{bug}"
      #puts "VERSION META= #{bug['fields']['fixVersions']}"

      bug['fields']['fixVersions']['allowedValues'].each do |v|
        @versions[v['name']] = true
      end
      
    end

    
  end
end
