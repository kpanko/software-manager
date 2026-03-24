Add a new milestone to the project, inserting it at the right position
in MILESTONES.md and creating the corresponding GitHub milestone and issues.

## Steps

### 1. Gather context

Read VISION.md and MILESTONES.md. Understand the existing milestone order
and which ones are done, in-progress, or planned.

### 2. Define the milestone

Ask the user:
- What is this milestone? (goal, one sentence)
- Where does it fit? (after which existing milestone)

If the user is vague, use a Plan subagent to propose a concrete goal,
acceptance criteria, and task list based on VISION.md and the surrounding
milestones. Present the proposal and revise until approved.

### 3. Assign a number and name

Insert the milestone in the correct position. If it lands between existing
milestones, renumber the ones after it (M3 becomes M4, etc.) in both
MILESTONES.md and — if GitHub is configured — rename the GitHub milestones
to match:
```
MILESTONE_NUM=$(gh api repos/OWNER/REPO/milestones \
  --jq '.[] | select(.title == "OLD TITLE") | .number')
gh api repos/OWNER/REPO/milestones/$MILESTONE_NUM \
  --method PATCH -f title="NEW TITLE"
```

### 4. Update MILESTONES.md

Insert the new milestone in the correct position with:
- Status: `planned` (or `in-progress` if it should start immediately)
- Goal
- Acceptance criteria
- Task list

### 5. Create the GitHub milestone

[GitHub only]
```
gh api repos/OWNER/REPO/milestones \
  --method POST \
  -f title="MILESTONE TITLE" \
  -f description="MILESTONE GOAL"
```

### 6. Create issues

[GitHub only] For each task, create an issue and add it to the project board:
```
ISSUE_URL=$(gh issue create \
  --repo OWNER/REPO \
  --title "TITLE" \
  --body "BODY" \
  --label "cc-generated,backlog" \
  --milestone "MILESTONE TITLE")

gh project item-add PROJECT_NUMBER \
  --owner OWNER \
  --url "$ISSUE_URL"
```
The body should include context, approach, and acceptance criteria.
Record each issue number in MILESTONES.md next to its task:
`- [ ] Task name (#N)`

### 7. Confirm

Report to the user:
- The new milestone and where it was inserted
- Any milestones that were renumbered
- Links to the created issues
