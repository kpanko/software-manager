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
