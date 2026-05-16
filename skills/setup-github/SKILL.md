---
name: setup-github
description: One-time setup: initialize GitHub labels, a project board, and a Status field for issue tracking.
---

One-time setup: initialize GitHub labels, a project board, and a Status
field for this project. Run this once after creating the repo.

## Steps

1. Detect the repo from git remote:
   ```
   git remote get-url origin
   ```
   Parse `owner/repo` from the URL. Confirm with the user.

2. Create labels (skip any that already exist):
   ```
   gh label create "cc-generated"  --color "0075ca" --description "Created by automated agent"
   gh label create "backlog"       --color "e4e669" --description "Not yet started"
   gh label create "in-progress"   --color "0052cc" --description "Currently being worked on"
   gh label create "blocked"       --color "d93f0b" --description "Blocked — needs input"
   gh label create "ready-for-pr"  --color "0e8a16" --description "Implemented, PR not yet open"
   ```

3. Create a GitHub Project board and link the repo to it:
   ```
   gh project create --owner OWNER --title "REPO_NAME"
   ```
   Capture the project number from the output, then link the repo:
   ```
   gh project link PROJECT_NUMBER --owner OWNER --repo REPO
   ```

4. Write the config to GITHUB.md:
   ```
   repo:           owner/repo
   project_number: N
   ```

5. Tell the user the automated setup is complete, then give these
   instructions for the one manual step — adding a Board view grouped
   by Milestone, which requires the GitHub web UI:

   > 1. Open the project at: https://github.com/users/OWNER/projects/PROJECT_NUMBER
   >    (or https://github.com/orgs/OWNER/projects/PROJECT_NUMBER for an org)
   > 2. Click **+ New view** (next to the default Table view tab)
   > 3. Select **Board**
   > 4. Click the **Group** control and set it to **Milestone**
   >
   > Issues will now appear as columns per milestone. Issue labels
   > (backlog, in-progress, blocked, ready-for-pr) are the source of
   > truth for status — the default Status field on the board is unused.
