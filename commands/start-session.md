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
- Run the project's test suite if one exists.
- If there are no automated tests, manually verify the acceptance
  criteria from the issue.
- Fix any failures before proceeding.

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
- Check off the task in MILESTONES.md.
- Update STATUS.md.
- Report what was done and the PR link.
- Ask: "Ready for the next issue, or done for today?"

If the user says done, run the end-of-session update:
- Update STATUS.md: in-progress, next up, blockers, key context.
- Set "Last updated" to today's date.
