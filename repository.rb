require 'json'

module Github

  class Repository

    def initialize(org, name)
      @org = org
      @name = name

    end

    def milestones(params) # {:state => "open"}
      result = github_api({:repo => @name, :org => @org}, "milestones", params)
      openMilestones = {}

      JSON.parse(result.body).each do |milestone|
        openMilestones[milestone["title"]] = milestone
      end

      openMilestones
    end

    def issues(params)
      puts "repo #{repo}, milestone #{milestone}"

      lastPage = false

      issues = []

      while !lastPage
      

        result = github_api({:repo => @name, :org => @org}, "issues", params)

        issueSet = JSON.parse(result.body)
        issues << issueSet

        pagination = result.header["link"]
        puts pagination

        

        

      end

      issues.flatten
    end


    def issuesForMilestone(milestone)
      puts "repo #{repo}, milestone #{milestone}"
      milestones = openMilestones(@name)
      thisMilestone = milestones[milestone]

      puts "No such milestone #{milestone}" if thisMilestone.nil?

      result = github_api({:repo => @name, :org => @org}, "issues", {:state => "open", :milestone => thisMilestone["number"]})

      puts result.code
      puts result.body
      puts result.header.keys

      pagination = result.header["link"]
      puts pagination

      JSON.parse(result.body)
    end
    



  end


end
