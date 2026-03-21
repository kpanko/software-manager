One-time setup: initialize GitHub labels and a project board for this project.
Run this once after creating the repo, before /kickoff.

## Steps

1. Detect the repo from git remote:
   ```
   git remote get-url origin
   ```
   Parse `owner/repo` from the URL. Confirm with the user.

2. Create labels (skip any that already exist):
   ```
   gh label create "cc-generated"  --color "0075ca" --description "Created by Claude Code"
   gh label create "backlog"       --color "e4e669" --description "Not yet started"
   gh label create "in-progress"   --color "0052cc" --description "Currently being worked on"
   gh label create "blocked"       --color "d93f0b" --description "Blocked — needs input"
   gh label create "ready-for-pr"  --color "0e8a16" --description "Implemented, PR not yet open"
   ```

3. Create a GitHub Project board:
   ```
   gh project create --owner OWNER --title "PROJECT_NAME"
   ```
   Capture the project number from the output.

4. Write the config to GITHUB.md:
   ```
   repo:           owner/repo
   project_number: N
   ```

5. Confirm to the user:
   - Labels created
   - Project board URL
   - "You're ready to run /kickoff"
