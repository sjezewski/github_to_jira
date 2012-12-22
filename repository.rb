require 'json'

module Github

  class Repository

    def initialize(org, name)
      @apiContext = API.new(org,name)
    end

    def milestones(params={:state => "open"})
      result = @apiContext.execute("milestones", params)
      openMilestones = {}

      JSON.parse(result.body).each do |milestone|
        openMilestones[milestone["title"]] = milestone
      end

      openMilestones
    end

    def issues(params={:state => "open"})
      lastPage = false

      issues = []

      while !lastPage
        result = @apiContext.execute("issues", params)

        issueSet = JSON.parse(result.body)
        issues << issueSet

        pagination = result.header["link"]
        puts pagination
      end

      issues.flatten
    end   

  end


end
