require 'json'

module Github

  class Repository

    def initialize(org, name)
      @apiContext = API.new(org,name)
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
        puts "# issues: #{issueSet.size}"
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
        issues.each do |issue|
          result = @apiContext.execute(issue["comments_url"])
          comments = JSON.parse(result.body)
          issue["comments"] = comments
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

      puts pages

      pages
    end

  end


end
