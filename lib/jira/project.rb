require_relative 'api'
require 'erb'

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
          :description => render_body(details),
          :issuetype => {:name => "Bug"},
          :assignee => {:name => details["assignee"] },
          :labels => ["migrated_from_github"]
        }
      }

      if details["milestone"]["name"] != "none"
        body[:fields][:fixVersions] = [{:name => details["milestone"]["name"]}]
      end

      result = @context.execute("issue", {}, body)

      return result unless result['error'].nil?

      JSON.parse(result.body)
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

      bug['fields']['fixVersions']['allowedValues'].each do |v|
        @versions[v['name']] = true
      end
      
    end

    def render_body(fields)
      template_path = File.join(File.split(__FILE__)[0..-2], "body.md.erb")
      template=ERB.new(File.read(template_path))
      template.result(binding)
    end


  end
end
