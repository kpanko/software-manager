---
name: create-issue
description: Draft and file a GitHub issue for a task, adding it to the project backlog.
---

Draft and file a GitHub issue for a task, adding it to the project backlog.
Use this when you want to capture an idea or task without implementing it immediately.

## Steps

1. If the user provided a description as an argument, use it as the starting
   point. Otherwise ask: "What's the task? Describe it briefly."

2. Draft the issue:

   **Title:** short, imperative ("Add user auth", "Fix race condition in cache")

   **Body:**
   ```markdown
   ## Context
   [Why this needs to be done. What problem it solves.]

   ## Approach
   [How to implement it — enough detail that an agent can pick this up cold
    and know where to start. Reference specific files, functions, or patterns
    if relevant.]

   ## Acceptance criteria
   - [ ] [concrete, testable criterion]
   - [ ] [...]

   ## Notes
   [Constraints, references, related issues, or anything else relevant.]
   ```

3. Show the draft to the user. Ask: "Does this look right?"
   Revise until approved.

4. Read GITHUB.md for the repo. If not configured, ask the user for owner/repo.

5. Check which GitHub milestones exist:
   ```
   gh api repos/OWNER/REPO/milestones --jq '.[].title'
   ```
   If milestones exist, ask the user which one this issue belongs to
   (or "none / backlog" if it's not tied to a milestone yet).

6. Create the issue and immediately add it to the project board:
   ```
   ISSUE_URL=$(gh issue create \
     --repo OWNER/REPO \
     --title "TITLE" \
     --body "BODY" \
     --label "cc-generated,backlog" \
     --milestone "MILESTONE TITLE")  # omit if no milestone

   gh project item-add PROJECT_NUMBER \
     --owner OWNER \
     --url "$ISSUE_URL"
   ```
   Read OWNER, REPO, and PROJECT_NUMBER from GITHUB.md. If GITHUB.md has
   no project_number, skip the second command.

7. Output the issue URL. Tell the user they can pick it up later with /kickoff
   or implement it now by referencing the issue number.
