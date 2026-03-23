Start a working session on this project.

## Orientation

1. Read VISION.md, MILESTONES.md, STATUS.md, and DECISIONS.md (skip any
   that don't exist yet).
2. [GitHub only] Run:
   ```
   gh issue list --repo OWNER/REPO --label "in-progress" --json number,title,url
   gh issue list --repo OWNER/REPO --label "backlog" --json number,title,url
   ```
3. Print a brief orientation (3-5 sentences): what the project is, which
   milestone is active, and where we left off.
4. List in-progress issues first, then the top backlog items.
5. Note any blockers.
6. Ask the user: "What do you want to work on? I can pick the next issue
   or you can call one out."

Do not start any implementation work until the user responds.

## Work loop

Once the user has indicated what to work on, follow this loop. Work one
issue at a time unless the user explicitly asks for parallel work or the
issues are clearly independent and trivial (e.g. renaming, copy changes).

### For each issue:

**1. Pick and claim**
- Confirm the issue with the user if there is any ambiguity.
- [GitHub only] Move it to in-progress:
  ```
  gh issue edit NUMBER --repo OWNER/REPO \
    --remove-label "backlog" --add-label "in-progress"
  ```

**2. Implement**
- Read the issue body for context, approach, and acceptance criteria.
- Make the changes. Update DECISIONS.md if a significant design choice
  is made.

**3. Test**
- Read the "How to Run" section of VISION.md for the install, run, and
  test commands. If that section is missing or incomplete, look for
  clues in package.json, Makefile, pyproject.toml, README, etc. and
  update VISION.md with what you find.
- Run the test command. If there is no test suite, at minimum run the
  app and verify it starts without errors.
- Actually execute the commands — do not assume the code works.
- If anything fails, fix it before committing. Do not commit broken code.

**4. Commit and push**
- Stage only files relevant to this issue.
- Write a commit message referencing the issue: `fix: short description (#N)`
- Push to the current branch.

**5. PR**
- [GitHub only] Open a PR with "closes #N" in the body:
  ```
  gh pr create \
    --repo OWNER/REPO \
    --title "SHORT TITLE (#N)" \
    --body "closes #N\n\nBRIEF DESCRIPTION"
  ```

**6. Wrap up**
- Check off the task in MILESTONES.md: change `- [ ]` to `- [x]`.
- Check whether all tasks in the current milestone are now checked off.
  If yes, this milestone is complete — run the milestone completion steps
  below before asking about the next issue.
- Update STATUS.md.
- Report what was done and the PR link.
- Ask: "Ready for the next issue, or done for today?"

If the user says done, run the end-of-session update:
- Update STATUS.md: in-progress, next up, blockers, key context.
- Set "Last updated" to today's date.

### Milestone completion steps

Run these when all tasks in a milestone are checked off:

1. Update MILESTONES.md: change the milestone status from `in-progress`
   to `done`. Set the next milestone to `in-progress`.
2. [GitHub only] Close the GitHub milestone:
   ```
   MILESTONE_NUM=$(gh api repos/OWNER/REPO/milestones \
     --jq '.[] | select(.title == "MILESTONE TITLE") | .number')

   gh api repos/OWNER/REPO/milestones/$MILESTONE_NUM \
     --method PATCH -f state=closed
   ```
3. Update STATUS.md to reflect the new active milestone.
4. Tell the user the milestone is closed and what the next one is.
