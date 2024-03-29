require 'json'

module Github

  class Repository

    def initialize(org, name, credentials)
      @apiContext = API.new(org, name, credentials)
    end

    def milestones(params={:state => "open"})
      result = @apiContext.execute("milestones", params)
      milestones_by_name = {}

      JSON.parse(result.body).each do |milestone|
        milestones_by_name[milestone["title"]] = milestone
      end

      # Usually want unfiled ones too
      milestones_by_name["none"] = {"number" => "none"}

      milestones_by_name
    end

    def issues(params={:state => "open"}, with_comments=true)
      lastPage = false

      issues = []

      while !lastPage
        result = @apiContext.execute("issues", params)

        issueSet = JSON.parse(result.body)
        puts "# issues: #{issueSet.size}" if @debug
        issues << issueSet

        if result.header["link"].nil?
          lastPage = true
        else
          pagination = parse_pagination(result.header["link"])
          next_page = pagination["next"]
          params[:page] = next_page
          lastPage = true if next_page.nil?          
        end

      end

      issues.flatten!

      if with_comments
        issues.collect! do |issue|
          result = @apiContext.execute(issue["comments_url"])
          comments = JSON.parse(result.body)
          issue["comments"] = comments
          issue
        end
      end

      issues
    end   

    def issue(number)
      result = @apiContext.execute("issue", {}, {}, {:number => number})      
      JSON.parse(result.body)
    end

    private

    def parse_pagination(raw)  # <https://api.github.com/repos/moovweb/manhattan/issues?milestone=24&page=2>; rel=\"next\", <https://api.github.com/repos/moovweb/manhattan/issues?milestone=24&page=2>; rel=\"last\""
      pages = {}

      raw.split(",").each do |raw_page|
        raw_page =~ /\<.*?page=(.*?)\>.*?rel=\"(.*?)\"/
        pages[$2] = $1
      end

      puts pages if @debug

      pages
    end

  end


end
