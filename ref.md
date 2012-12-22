# Links

- [Basic Auth to get token](https://help.github.com/articles/creating-an-oauth-token-for-command-line-use)
- ok .. but then what the fuck do I use these client tokens for?
- [this guy](https://gist.github.com/2288960) says that you just need to do basic auth once to get a token. STill ... WTF did I setup the client id/secret for? Because i dont need it for this. Whatever, guess I'm not using oath
  - [this person agrees](http://www.lornajane.net/posts/2012/github-api-access-tokens-via-curl)
- [python script to use the aPI](http://agrimmsreality.blogspot.com/2012/05/sampling-github-api-v3-in-python.html)
  - although I get the auth token response,
  - I can't seem to use it the way this guy does ... oh well
- Yea ok ... so no client_* shit needed ... [github lies](http://developer.github.com/v3/oauth/#create-a-new-authorization) or I'm vastly misunderstanding the purpose of those fields