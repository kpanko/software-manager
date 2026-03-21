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

5. Create the issue:
   ```
   gh issue create \
     --repo OWNER/REPO \
     --title "TITLE" \
     --body "BODY" \
     --label "cc-generated,backlog"
   ```

6. If GITHUB.md has a project_number, add the issue to the project board:
   ```
   gh project item-add PROJECT_NUMBER --owner OWNER --url ISSUE_URL
   ```

7. Output the issue URL. Tell the user they can pick it up later with /kickoff
   or implement it now by referencing the issue number.
