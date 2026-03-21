# Project Management

This project uses a structured session workflow. Four files maintain state:

| File | Purpose | Stability |
|------|---------|-----------|
| `VISION.md` | Goals, non-goals, architecture, core principles | Rarely changes |
| `MILESTONES.md` | Major phases, tasks, acceptance criteria | Changes per phase |
| `STATUS.md` | In-progress work, next steps, blockers | Changes per session |
| `DECISIONS.md` | Architectural decision log | Append-only |

## Starting a Session

Run `/start-session`. It will read the above files and orient you.
Do not begin coding before running it.

## Ending a Session

Run `/end-session`. It will update STATUS.md and MILESTONES.md based on
what was accomplished. Do not skip this — it's how context survives
between sessions.

## During a Session

- When a task is completed, check it off in MILESTONES.md immediately.
- When a significant design decision is made, add it to DECISIONS.md.
- When you hit a blocker, add it to STATUS.md under Blockers.
- Do not modify VISION.md without explicitly discussing it with the user.

## Planning a Milestone

Run `/plan-milestone` to break down the next unstarted milestone into
concrete tasks using a planning agent.
