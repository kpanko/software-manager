---
name: end-session
description: Wrap up the current working session, save state, and commit and push session work.
---

Wrap up the current working session and save state.

1. Review the conversation history to identify what was accomplished.
2. Only ask the user a question if something specific is genuinely
   ambiguous after reviewing the conversation (e.g., it's unclear
   whether a half-finished change should be kept or reverted). Do not
   ask a generic "anything to add?" prompt.
3. Update STATUS.md:
   - Move completed items into "Recently Completed" (trim old ones if
     the list gets long).
   - Update "In Progress" to reflect current state.
   - Update "Next Up" with the logical next actions, drawn from
     MILESTONES.md.
   - Record any new blockers or open questions.
   - Update "Key Context" with anything non-obvious that future sessions
     need to know. Remove stale context.
   - Set "Last updated" to today's date.
4. For each task completed this session, check it off in MILESTONES.md:
   change `- [ ]` to `- [x]`. Then check whether all tasks in the
   milestone are now checked off. If yes:
   - Update the milestone status in MILESTONES.md to `done`.
   - Set the next milestone to `in-progress`.
   - [GitHub only] Close the GitHub milestone:
     ```
     MILESTONE_NUM=$(gh api repos/OWNER/REPO/milestones \
       --jq '.[] | select(.title == "MILESTONE TITLE") | .number')
     gh api repos/OWNER/REPO/milestones/$MILESTONE_NUM \
       --method PATCH -f state=closed
     ```
5. If a significant architectural decision was made, append it to
   DECISIONS.md.
6. [GitHub only] Read GITHUB.md for repo and project_number, then reconcile
   GitHub state with what actually happened this session:
   - For each issue that was fully implemented and has an open PR:
     - Ensure labels are `ready-for-pr` (remove `in-progress`):
       ```
       gh issue edit NUMBER --repo OWNER/REPO \
         --remove-label "in-progress" --add-label "ready-for-pr"
       ```
   - For each issue still being worked on, ensure it has `in-progress`
     and not `backlog`:
       ```
       gh issue edit NUMBER --repo OWNER/REPO \
         --remove-label "backlog" --add-label "in-progress"
       ```
   - For each issue that was abandoned or deferred back to backlog:
       ```
       gh issue edit NUMBER --repo OWNER/REPO \
         --remove-label "in-progress" --add-label "backlog"
       ```
   - For each issue that was worked but has no PR yet, leave a comment
     summarizing what was done and what remains:
       ```
       gh issue comment NUMBER --repo OWNER/REPO --body "SUMMARY"
       ```
   - List any open PRs so the user knows what needs review:
       ```
       gh pr list --repo OWNER/REPO --state open
       ```
7. Commit and push all uncommitted work:
   - Run `git status` to see what's modified or untracked.
   - Stage everything that was changed this session (source code, docs,
     config — anything that should be committed).
   - Do not stage secrets, build artifacts, or files the .gitignore
     would exclude.
   - Write a commit message summarizing what was done this session.
     If multiple issues were worked, mention them: `work: foo (#N), bar (#M)`
   - Push to the current branch.
   - If there is nothing to commit, skip this step.

8. Confirm to the user what was saved and show any open PRs.
