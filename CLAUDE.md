# Software Manager

This repo provides a session-based project management workflow for Claude Code.

## Structure

```
templates/          Doc templates to copy into a managed project
  VISION.md         Project goals, non-goals, architecture
  MILESTONES.md     Major phases and task breakdowns
  STATUS.md         Session state: in-progress, next up, blockers
  DECISIONS.md      Architectural decision log
  project-CLAUDE.md CLAUDE.md template for managed projects

commands/           Slash command definitions
  start-session.md  Orient at session start
  end-session.md    Save state at session end
  plan-milestone.md Break down a milestone with a planning agent

install.sh          Copies commands/ into ~/.claude/commands/
```

## Setting Up a New Managed Project

1. Copy `templates/` files into the project root.
2. Rename `project-CLAUDE.md` to `CLAUDE.md` (or append to existing).
3. Fill in VISION.md and the first milestone in MILESTONES.md.
4. Run `install.sh` once to install slash commands globally.

## Workflow

- Begin each session with `/start-session`
- End each session with `/end-session`
- Plan new milestones with `/plan-milestone`
