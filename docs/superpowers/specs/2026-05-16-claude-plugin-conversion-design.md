# Claude Plugin Conversion — Design

## Goal

Convert `software-manager` from an `install.sh`-distributed collection of
slash commands into a public Claude Code marketplace plugin. Eliminate the
file-overwrite risk of dumping `.md` files directly into
`~/.claude/commands/`, replace the manual project-bootstrap `cp` step with
a slash command, and make the workflow installable via
`/plugin marketplace add` and `/plugin install`.

## Non-goals

- Behavior changes to existing commands. Each is converted as-is.
- Adding new functionality beyond the new `setup-project` skill.
- Backwards compatibility with the old `install.sh` flow. The script and
  the `commands/` and `templates/` directories are deleted; the user is
  the sole existing consumer and will migrate in a single step.

## Directory layout

```
software-manager/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── skills/
│   ├── vision/SKILL.md
│   ├── kickoff/SKILL.md
│   ├── start-session/SKILL.md
│   ├── end-session/SKILL.md
│   ├── add-milestone/SKILL.md
│   ├── create-issue/SKILL.md
│   ├── setup-github/SKILL.md
│   └── setup-project/
│       ├── SKILL.md
│       └── templates/
│           ├── VISION.md
│           ├── MILESTONES.md
│           ├── STATUS.md
│           ├── DECISIONS.md
│           ├── GITHUB.md
│           └── project-CLAUDE.md
├── README.md
├── CLAUDE.md
└── .gitignore
```

The repo serves as both the marketplace and the single plugin it lists.

## Manifests

`.claude-plugin/plugin.json`:

```json
{
  "name": "software-manager",
  "version": "0.1.0",
  "description": "Session-based project management workflow for Claude Code.",
  "author": { "name": "Kevin Panko" }
}
```

`.claude-plugin/marketplace.json`:

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

Skills are auto-discovered from `skills/`; the plugin manifest does not
list them individually.

## Skill conversion

Each existing `commands/<name>.md` becomes `skills/<name>/SKILL.md`. The
body of every file is preserved verbatim. The only addition is YAML
frontmatter so Claude Code registers the file as a skill:

```yaml
---
name: <kebab-case-name>
description: <action-phrased one-liner — what the skill does when invoked>
---
```

The `description` is what Claude uses for skill discovery and what
displays in the `/` menu. For these user-invoked workflows, it should
read as an action (e.g. "Start a working session on this project.").
Descriptions for each skill:

| Skill | Description |
|---|---|
| vision | Conduct a structured conversation to capture the project vision, then write VISION.md. |
| kickoff | Turn VISION.md into a milestone plan, then execute it autonomously with milestone checkpoints. |
| start-session | Start a working session on this project. Read state files, orient, and ask what to focus on. |
| end-session | Wrap up the current working session, save state, and commit and push session work. |
| add-milestone | Insert a new milestone at any position in MILESTONES.md and create the matching GitHub milestone and issues. |
| create-issue | Draft and file a GitHub issue for a task, adding it to the project backlog. |
| setup-github | One-time setup: initialize GitHub labels, a project board, and a Status field for issue tracking. |
| setup-project | Bootstrap a new managed project by copying VISION/MILESTONES/STATUS/DECISIONS/CLAUDE templates into the current directory. |

## New skill: setup-project

Replaces the manual `cp templates/*` step that the current README
prescribes. Lives at `skills/setup-project/SKILL.md` and owns the
template files at `skills/setup-project/templates/`.

Behavior when invoked:

1. For each of `VISION.md`, `MILESTONES.md`, `STATUS.md`, `DECISIONS.md`,
   `GITHUB.md`: if the file does not exist in the current working
   directory, copy it from `${CLAUDE_PLUGIN_ROOT}/skills/setup-project/templates/`.
   If it already exists, skip and report skipped.
2. For `project-CLAUDE.md`: if no `CLAUDE.md` exists in the project,
   copy it as `CLAUDE.md`. If one exists, ask the user whether to
   append the template contents or skip.
3. Print a summary of created and skipped files.
4. Suggest `/vision` as the next step.

The skill is idempotent — re-running it after deleting one of the
scaffold files restores only that file.

`GITHUB.md` is included in the scaffold copy because it is one of the
templates today; the user can still ignore it if not using GitHub
integration.

## What gets deleted

- `commands/` — contents migrated to `skills/<name>/SKILL.md`.
- `templates/` — contents migrated to `skills/setup-project/templates/`.
- `install.sh` and `install.ps1` — replaced by `/plugin install`.

## README updates

Three changes:

1. Replace the "Install the slash commands (once)" section with:
   ```
   /plugin marketplace add pankok/software-manager
   /plugin install software-manager
   ```
2. Replace the six-line `cp` block under "Start a new managed project"
   with a single line: `/setup-project`.
3. No changes to the "Commands reference" table (the slash names
   stay identical post-conversion).

## User migration (one-time)

The user has the old commands installed at `~/.claude/commands/*.md` from
prior runs of `install.sh`. After installing the plugin, those duplicates
will shadow or conflict with the plugin's skills. The README's
installation section gains a "Migrating from the old install.sh"
subsection with the Git Bash cleanup command (which is the shell Claude
Code runs under on this user's machine):

```
rm ~/.claude/commands/{vision,kickoff,start-session,end-session,add-milestone,create-issue,setup-github}.md
```

This is the only manual step required for migration.

## Verification

After conversion (test locally before pushing to GitHub):

1. `/plugin marketplace add <local-repo-path>` succeeds and lists the
   `software-manager` plugin. Once verified locally, the production
   form is `/plugin marketplace add pankok/software-manager`.
2. `/plugin install software-manager` succeeds; all eight skills appear
   in the `/` menu.
3. Each of the seven converted skills is invocable and behaves
   identically to the pre-conversion command.
4. `/setup-project` in an empty directory creates the five scaffold
   files plus `CLAUDE.md`; re-running it reports all files skipped.
