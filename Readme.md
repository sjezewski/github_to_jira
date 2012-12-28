# Github to JIRA

Migrate issues from github to JIRA.


## Features

- Convert/preserve all milestones (including issues without a milestone)
- Map assignee from github to jira user
- Preserve labels
- Preserve comments
- All migrated issues are labelled `migrated_from_github` in case you need to perform batch operations post migration

## Anti-Features

The script does NOT:

- close github issues after conversion
- preserve github actions (close/reopen issue)
- preserve github attachments
- preserve markdown/html formatting -- all issues are converted as text
  - some markdown features are supported on JIRA, others are not


## Usage

- Use a config file to specify:
  - your github / jira repos to convert
  - your github / jira usernames
  - your jira config
- Run the script and specify the config file: `./bin/convert config/example.yml`
  - You'll be prompted for you github / jira credentials
  - These are only stored in memory -- the script uses basic auth to authenticate w both APIs (its encrypted over https)

## Recommendations

- Specify a dummy JIRA project for dry runs
- Make a different config per repo map so that once a successful run is complete you can move on

## Disclaimer

As is! Useful to me, hopefully to you.

- The conversion is not idempotent! If it fails mid project and you re-run it you will have duplicate tickets
- If a batch fails midway to convert the project, use the `migrated_from_github` label to do a batch delete and re-migrate
