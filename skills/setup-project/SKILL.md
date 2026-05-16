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
