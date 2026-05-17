# Claude Plugin Conversion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert `software-manager` from `install.sh`-distributed slash commands into a Claude Code marketplace plugin.

**Architecture:** Repo serves as both marketplace and plugin. Existing 7 commands convert 1:1 to skills (folder + `SKILL.md` with YAML frontmatter). A new `setup-project` skill owns the scaffolding templates and replaces the manual `cp templates/*` step. `install.sh`, `install.ps1`, `commands/`, and `templates/` are deleted.

**Tech Stack:** Markdown skills, JSON manifests. No runtime dependencies.

**Spec:** `docs/superpowers/specs/2026-05-16-claude-plugin-conversion-design.md`

---

## File Structure

Files created:
- `.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
- `skills/vision/SKILL.md`
- `skills/kickoff/SKILL.md`
- `skills/start-session/SKILL.md`
- `skills/end-session/SKILL.md`
- `skills/add-milestone/SKILL.md`
- `skills/create-issue/SKILL.md`
- `skills/setup-github/SKILL.md`
- `skills/setup-project/SKILL.md` (new skill — not just a port)

Files moved (via `git mv` to preserve history):
- `templates/VISION.md` → `skills/setup-project/templates/VISION.md`
- `templates/MILESTONES.md` → `skills/setup-project/templates/MILESTONES.md`
- `templates/STATUS.md` → `skills/setup-project/templates/STATUS.md`
- `templates/DECISIONS.md` → `skills/setup-project/templates/DECISIONS.md`
- `templates/GITHUB.md` → `skills/setup-project/templates/GITHUB.md`
- `templates/project-CLAUDE.md` → `skills/setup-project/templates/project-CLAUDE.md`

Files deleted:
- `commands/*.md` (7 files; bodies migrate into the new SKILL.md files)
- `install.sh`
- `install.ps1`
- `commands/` (empty directory)
- `templates/` (empty directory)

Files modified:
- `README.md`

All shell commands assume Git Bash (per the user's CLAUDE.md, that is what Claude Code runs under on this machine).

---

### Task 1: Add plugin and marketplace manifests

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `.claude-plugin/marketplace.json`

- [ ] **Step 1: Create the `.claude-plugin` directory**

```bash
mkdir -p .claude-plugin
```

- [ ] **Step 2: Write `plugin.json`**

Create `.claude-plugin/plugin.json` with this content:

```json
{
  "name": "software-manager",
  "version": "0.1.0",
  "description": "Session-based project management workflow for Claude Code.",
  "author": { "name": "Kevin Panko" }
}
```

- [ ] **Step 3: Write `marketplace.json`**

Create `.claude-plugin/marketplace.json` with this content:

```json
{
  "name": "software-manager",
  "owner": { "name": "Kevin Panko" },
  "plugins": [
    {
      "name": "software-manager",
      "source": ".",
      "description": "Session-based project management workflow for Claude Code."
    }
  ]
}
```

- [ ] **Step 4: Validate both files are valid JSON**

```bash
python -m json.tool .claude-plugin/plugin.json > /dev/null && echo "plugin.json OK"
python -m json.tool .claude-plugin/marketplace.json > /dev/null && echo "marketplace.json OK"
```

Expected output:
```
plugin.json OK
marketplace.json OK
```

- [ ] **Step 5: Commit**

```bash
git add .claude-plugin/
git commit -m "plugin: add manifest and marketplace listing"
```

---

### Task 2: Convert the seven existing commands to skills

Each conversion is structurally identical: create `skills/<name>/SKILL.md` containing YAML frontmatter prepended to the exact body of `commands/<name>.md`, then `git rm` the old command file. The body content is not modified.

**Files:**
- Create: `skills/vision/SKILL.md`
- Create: `skills/kickoff/SKILL.md`
- Create: `skills/start-session/SKILL.md`
- Create: `skills/end-session/SKILL.md`
- Create: `skills/add-milestone/SKILL.md`
- Create: `skills/create-issue/SKILL.md`
- Create: `skills/setup-github/SKILL.md`
- Delete: `commands/vision.md`, `commands/kickoff.md`, `commands/start-session.md`, `commands/end-session.md`, `commands/add-milestone.md`, `commands/create-issue.md`, `commands/setup-github.md`

- [ ] **Step 1: Convert `vision`**

```bash
mkdir -p skills/vision
{
  printf -- '---\nname: vision\ndescription: Conduct a structured conversation to capture the project vision, then write VISION.md.\n---\n\n'
  cat commands/vision.md
} > skills/vision/SKILL.md
git rm commands/vision.md
```

- [ ] **Step 2: Convert `kickoff`**

```bash
mkdir -p skills/kickoff
{
  printf -- '---\nname: kickoff\ndescription: Turn VISION.md into a milestone plan, then execute it autonomously with milestone checkpoints.\n---\n\n'
  cat commands/kickoff.md
} > skills/kickoff/SKILL.md
git rm commands/kickoff.md
```

- [ ] **Step 3: Convert `start-session`**

```bash
mkdir -p skills/start-session
{
  printf -- '---\nname: start-session\ndescription: Start a working session on this project. Read state files, orient, and ask what to focus on.\n---\n\n'
  cat commands/start-session.md
} > skills/start-session/SKILL.md
git rm commands/start-session.md
```

- [ ] **Step 4: Convert `end-session`**

```bash
mkdir -p skills/end-session
{
  printf -- '---\nname: end-session\ndescription: Wrap up the current working session, save state, and commit and push session work.\n---\n\n'
  cat commands/end-session.md
} > skills/end-session/SKILL.md
git rm commands/end-session.md
```

- [ ] **Step 5: Convert `add-milestone`**

```bash
mkdir -p skills/add-milestone
{
  printf -- '---\nname: add-milestone\ndescription: Insert a new milestone at any position in MILESTONES.md and create the matching GitHub milestone and issues.\n---\n\n'
  cat commands/add-milestone.md
} > skills/add-milestone/SKILL.md
git rm commands/add-milestone.md
```

- [ ] **Step 6: Convert `create-issue`**

```bash
mkdir -p skills/create-issue
{
  printf -- '---\nname: create-issue\ndescription: Draft and file a GitHub issue for a task, adding it to the project backlog.\n---\n\n'
  cat commands/create-issue.md
} > skills/create-issue/SKILL.md
git rm commands/create-issue.md
```

- [ ] **Step 7: Convert `setup-github`**

```bash
mkdir -p skills/setup-github
{
  printf -- '---\nname: setup-github\ndescription: One-time setup: initialize GitHub labels, a project board, and a Status field for issue tracking.\n---\n\n'
  cat commands/setup-github.md
} > skills/setup-github/SKILL.md
git rm commands/setup-github.md
```

- [ ] **Step 8: Verify all seven skills exist with frontmatter**

```bash
for f in skills/vision skills/kickoff skills/start-session skills/end-session skills/add-milestone skills/create-issue skills/setup-github; do
  if [ -f "$f/SKILL.md" ] && head -1 "$f/SKILL.md" | grep -q '^---$'; then
    echo "OK: $f/SKILL.md"
  else
    echo "MISSING OR BAD: $f/SKILL.md"
  fi
done
```

Expected: seven `OK:` lines, no `MISSING OR BAD:` lines.

- [ ] **Step 9: Verify each skill's `name` field matches its directory**

```bash
for f in skills/*/SKILL.md; do
  dir=$(basename "$(dirname "$f")")
  declared=$(awk '/^name:/ { print $2; exit }' "$f")
  [ "$dir" = "$declared" ] && echo "OK: $dir" || echo "MISMATCH: dir=$dir name=$declared"
done
```

Expected: only `OK:` lines.

- [ ] **Step 10: Verify the commands directory is empty**

```bash
ls commands/ 2>/dev/null
```

Expected: no output (all seven files have been `git rm`'d).

- [ ] **Step 11: Commit**

```bash
git add skills/
git commit -m "plugin: convert slash commands to skills"
```

---

### Task 3: Create the new `setup-project` skill and move templates into it

**Files:**
- Create: `skills/setup-project/SKILL.md`
- Move: `templates/VISION.md` → `skills/setup-project/templates/VISION.md`
- Move: `templates/MILESTONES.md` → `skills/setup-project/templates/MILESTONES.md`
- Move: `templates/STATUS.md` → `skills/setup-project/templates/STATUS.md`
- Move: `templates/DECISIONS.md` → `skills/setup-project/templates/DECISIONS.md`
- Move: `templates/GITHUB.md` → `skills/setup-project/templates/GITHUB.md`
- Move: `templates/project-CLAUDE.md` → `skills/setup-project/templates/project-CLAUDE.md`

- [ ] **Step 1: Move the templates with `git mv` to preserve history**

```bash
mkdir -p skills/setup-project/templates
git mv templates/VISION.md           skills/setup-project/templates/VISION.md
git mv templates/MILESTONES.md       skills/setup-project/templates/MILESTONES.md
git mv templates/STATUS.md           skills/setup-project/templates/STATUS.md
git mv templates/DECISIONS.md        skills/setup-project/templates/DECISIONS.md
git mv templates/GITHUB.md           skills/setup-project/templates/GITHUB.md
git mv templates/project-CLAUDE.md   skills/setup-project/templates/project-CLAUDE.md
```

- [ ] **Step 2: Write `skills/setup-project/SKILL.md`**

Create `skills/setup-project/SKILL.md` with this content:

````markdown
---
name: setup-project
description: Bootstrap a new managed project by copying VISION/MILESTONES/STATUS/DECISIONS/CLAUDE templates into the current directory.
---

Bootstrap a new managed project by copying scaffolding templates into
the current working directory. Safe to re-run — existing files are
never overwritten.

## What this does

The templates live at `${CLAUDE_PLUGIN_ROOT}/skills/setup-project/templates/`.

For each of these scaffold files, copy it into the current directory
if and only if it does not already exist there:

- `VISION.md`
- `MILESTONES.md`
- `STATUS.md`
- `DECISIONS.md`
- `GITHUB.md`

For `project-CLAUDE.md`, handle CLAUDE.md specially:
- If `CLAUDE.md` does not exist in the current directory, copy
  `project-CLAUDE.md` from the templates folder as `CLAUDE.md`.
- If `CLAUDE.md` already exists, ask the user: "CLAUDE.md already
  exists. Append the template contents, or skip?" Then act accordingly.

## Steps to execute

1. Resolve the templates directory: `${CLAUDE_PLUGIN_ROOT}/skills/setup-project/templates/`.
2. For each of `VISION.md`, `MILESTONES.md`, `STATUS.md`, `DECISIONS.md`, `GITHUB.md`:
   - If absent from the current directory, copy from templates.
   - If present, record as skipped.
3. Handle `CLAUDE.md` per the rule above.
4. Print a summary listing files created and files skipped.
5. Suggest the user run `/vision` next.
````

- [ ] **Step 3: Verify the SKILL.md frontmatter parses**

```bash
head -4 skills/setup-project/SKILL.md
```

Expected output (exact):
```
---
name: setup-project
description: Bootstrap a new managed project by copying VISION/MILESTONES/STATUS/DECISIONS/CLAUDE templates into the current directory.
---
```

- [ ] **Step 4: Verify the templates folder contains all six files**

```bash
ls skills/setup-project/templates/
```

Expected output:
```
DECISIONS.md
GITHUB.md
MILESTONES.md
STATUS.md
VISION.md
project-CLAUDE.md
```

- [ ] **Step 5: Verify the old `templates/` directory is now empty**

```bash
ls templates/ 2>/dev/null
```

Expected: no output.

- [ ] **Step 6: Commit**

```bash
git add skills/setup-project/
git commit -m "plugin: add setup-project skill owning bootstrap templates"
```

---

### Task 4: Delete the obsolete install scripts and empty directories

**Files:**
- Delete: `install.sh`
- Delete: `install.ps1`
- Delete: `commands/` (empty directory left after Task 2)
- Delete: `templates/` (empty directory left after Task 3)

- [ ] **Step 1: Remove the install scripts**

```bash
git rm install.sh install.ps1
```

- [ ] **Step 2: Remove the now-empty `commands/` and `templates/` directories**

Empty directories aren't tracked by git, so `rmdir` is sufficient:

```bash
rmdir commands templates
```

If either `rmdir` fails because the directory isn't empty, stop and investigate — Tasks 2 and 3 should have moved every file out.

- [ ] **Step 3: Verify the directories are gone**

```bash
ls -d commands templates 2>/dev/null
```

Expected: no output.

- [ ] **Step 4: Verify the install scripts are gone**

```bash
ls install.* 2>/dev/null
```

Expected: no output.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "plugin: remove obsolete install scripts and empty directories"
```

---

### Task 5: Rewrite `README.md` and `CLAUDE.md` for plugin installation

**Files:**
- Modify: `README.md`
- Modify: `CLAUDE.md`

The README has three sections that need to change. Other sections (core idea, two modes, the four documents, GitHub integration, realistic expectations, commands reference) stay as-is except for one table addition.

The repo's own `CLAUDE.md` describes the structure of this project and references the now-deleted `templates/`, `commands/`, `install.sh`, and a stale `plan-milestone.md`. It needs a small rewrite to match the plugin layout.

- [ ] **Step 1: Replace the "Install the slash commands (once)" section**

Find the block in `README.md` starting at the `### Install the slash commands (once)` heading and continuing through `Restart CC after installing.` Replace the entire block with:

````markdown
### Install the plugin (once)

```
/plugin marketplace add pankok/software-manager
/plugin install software-manager
```

Restart Claude Code if the new skills don't appear in the `/` menu.

#### Migrating from the old install.sh

If you previously installed via `install.sh`, remove the leftover
command files from Git Bash:

```bash
rm ~/.claude/commands/{vision,kickoff,start-session,end-session,add-milestone,create-issue,setup-github}.md
```
````

- [ ] **Step 2: Replace the "Start a new managed project" section**

Find the block starting at `### Start a new managed project` through `Then open Claude Code in that directory and run `/vision`.` Replace the entire block with:

````markdown
### Start a new managed project

In the new project directory, run:

```
/setup-project
```

This copies the scaffolding files (`VISION.md`, `MILESTONES.md`,
`STATUS.md`, `DECISIONS.md`, `GITHUB.md`) into the current directory
and sets up `CLAUDE.md`. Re-running it is safe — existing files are
never overwritten.

Then run `/vision`.
````

- [ ] **Step 3: Add `/setup-project` to the Commands reference table**

In the `## Commands reference` table near the bottom of the README, insert a new row immediately above the `/vision` row:

```markdown
| `/setup-project` | Starting a new managed project — copies scaffolding templates into the current directory |
```

- [ ] **Step 4: Verify the README has no stale references**

```bash
grep -n 'install\.sh\|install\.ps1\|templates/' README.md
```

Expected: the only matches are inside the "Migrating from the old install.sh" subsection. Any other matches indicate a stale reference that needs cleanup.

- [ ] **Step 5: Rewrite the repo's own `CLAUDE.md`**

Replace the entire current contents of `CLAUDE.md` (which describes the pre-plugin layout) with the following:

````markdown
# Software Manager

This repo is a Claude Code marketplace plugin that provides a
session-based project management workflow.

## Structure

```
.claude-plugin/        Plugin and marketplace manifests
  plugin.json
  marketplace.json

skills/                One folder per skill — Claude Code auto-discovers these
  vision/              /vision — capture project vision
  kickoff/             /kickoff — plan and execute milestones
  start-session/       /start-session
  end-session/         /end-session
  add-milestone/       /add-milestone
  create-issue/        /create-issue
  setup-github/        /setup-github
  setup-project/       /setup-project — bootstrap a new managed project
    templates/         Scaffold files copied by /setup-project
```

## Workflow

- Bootstrap a managed project with `/setup-project`
- Begin each session with `/start-session`
- End each session with `/end-session`
- Plan new milestones with `/add-milestone` or `/kickoff`
````

- [ ] **Step 6: Commit**

```bash
git add README.md CLAUDE.md
git commit -m "docs: rewrite README and CLAUDE.md for plugin installation"
```

---

### Task 6: End-to-end verification

**Files:** none modified — verification only.

- [ ] **Step 1: Verify the final repo structure**

```bash
ls -A
```

Expected entries (order may vary):
```
.claude-plugin
.git
.gitignore
CLAUDE.md
README.md
docs
skills
```

There should be no `commands`, `templates`, `install.sh`, or `install.ps1`.

- [ ] **Step 2: Verify the eight skills exist**

```bash
ls skills/
```

Expected output:
```
add-milestone
create-issue
end-session
kickoff
setup-github
setup-project
start-session
vision
```

- [ ] **Step 3: Verify every SKILL.md has well-formed frontmatter and a matching `name`**

```bash
for f in skills/*/SKILL.md; do
  dir=$(basename "$(dirname "$f")")
  head -1 "$f" | grep -q '^---$' || { echo "BAD FRONTMATTER: $f"; continue; }
  declared=$(awk '/^name:/ { print $2; exit }' "$f")
  [ "$dir" = "$declared" ] || echo "NAME MISMATCH: dir=$dir name=$declared"
done
```

Expected: no output.

- [ ] **Step 4: Verify both manifests are valid JSON**

```bash
python -m json.tool .claude-plugin/plugin.json > /dev/null && echo "plugin.json OK"
python -m json.tool .claude-plugin/marketplace.json > /dev/null && echo "marketplace.json OK"
```

Expected:
```
plugin.json OK
marketplace.json OK
```

- [ ] **Step 5: Manual smoke test — install the plugin locally**

These steps must be run by the user inside Claude Code (the agent cannot run them itself).

1. Add the local repo as a marketplace: `/plugin marketplace add C:\Users\panko\src\software-manager`
2. Install: `/plugin install software-manager`
3. Type `/` and confirm all eight skills appear in the menu:
   `setup-project`, `vision`, `kickoff`, `start-session`, `end-session`, `add-milestone`, `create-issue`, `setup-github`.

If any skill is missing, the SKILL.md frontmatter or filename is wrong — re-check Step 3.

- [ ] **Step 6: Manual smoke test — bootstrap an empty project**

1. Create a temp directory and `cd` into it from Git Bash: `mkdir /tmp/sm-test && cd /tmp/sm-test`
2. Open Claude Code in that directory and run `/setup-project`.
3. Confirm `VISION.md`, `MILESTONES.md`, `STATUS.md`, `DECISIONS.md`, `GITHUB.md`, and `CLAUDE.md` are created.
4. Re-run `/setup-project` and confirm all six files are reported as skipped.

- [ ] **Step 7: Final cleanup commit (if needed)**

If Steps 1-6 surfaced no issues, no further commit is needed. If they did, fix and commit:

```bash
git add -A
git commit -m "plugin: fix issues found during end-to-end verification"
```

---

## Notes for the implementing engineer

- The skills system in Claude Code auto-discovers `skills/*/SKILL.md` files inside an installed plugin. There is no skill registry to update.
- `${CLAUDE_PLUGIN_ROOT}` is the environment variable that expands to the installed plugin's root directory at runtime. The `setup-project` skill uses it to locate its bundled templates regardless of where the user invokes the skill from.
- Skill `description` values are what surface in Claude Code's `/` menu and what Claude uses for skill discovery. Action-phrased descriptions ("Start a working session…") read better than noun phrases.
- The bodies of the seven converted command files are preserved verbatim. They reference project files like `VISION.md` and `MILESTONES.md` by name; those references continue to mean "in the managed project's working directory" and require no rewriting.
