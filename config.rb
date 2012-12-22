require 'erb'

user_id = {
  "hariananth" => "hari.ananth",
  "jose-espinosa" => "jose.espinosa",
  "mdayaram" => "manoj.dayaram",
  "zhigangc" => "zhigang.chen",
  "sjezewski" => "sean.jezewski",
  "hcatlin" => "hampton.catlin",
  "akhleung" => "aaron.leung",
  "mbyczkowski" => "mat.byczkowski",
  "jbussdieker" => "josh.bussdieker",
  "nmakiya" => "naseem.makiya",
  "malrase" => "michael.catlin"
}


github_repos = [
  "manhattan",
  "apollo"
]

root = "https://api.github.com"


$github_api_config = {
  "auth" => {
    :url => "#{root}/authorizations",
    :verb => :post
  },
  "issues" => {
#    :url => "https://api.github.com/repos/moovweb/manhattan/issues",
    :url => "#{root}/repos/moovweb/manhattan/issues",
    :verb => :get
  },
  "milestones" => {
    :url => "#{root}/repos/moovweb/<%=context[:repo]%>/milestones",
    :verb => :get
  },
  "issues" => {
    :url => "#{root}/repos/moovweb/<%=context[:repo]%>/issues",
    :verb => :get
  }
}

def github_api_method(action, context={})
  method = $github_api_config[action]

  url_template = ERB.new(method[:url])
  method[:url] = url_template.result(binding)

  method
end



## Below here is useless ##

_gh_sess="BAh7CjoPc2Vzc2lvbl9pZCIlOTA4NGE2MWFiNDE3NWNjYThkNzdmYWI4ZjhhOTVjNjE6EF9jc3JmX3Rva2VuIjFzbng3NDJyOU03MDNINW1sZkMwNm9HMlBjODgzYmtkdFZ5VWRKS1FScndrPToQZmluZ2VycHJpbnQiJTRmMWNmOTQzMTg4NGJmZTI1ZGFlMDljOTU1MTAwMTgxOgl1c2VyaQPBHwkiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7BjoKZXJyb3IiJEluY29ycmVjdCB1c2VybmFtZSBvciBwYXNzd29yZC4GOgpAdXNlZHsGOwpU"

# OAuth

$oauth = {
  "client_secret" => "5da4cbb9b12d1499b001064112c975869c4643c1",
  "client_id" => "80d26167e95f5a8350d3"
}






