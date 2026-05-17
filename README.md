# Software Manager

A workflow system for managing personal software projects with Claude Code.
Keeps context alive across sessions and supports autonomous execution.

---

## The core idea

Claude Code is great at one task at a time but loses the plot on bigger
projects. This system gives it the structure to manage a full project:
vision, milestones, session state, and a manager agent that coordinates
implementation on your behalf.

---

## Two modes

### Autonomous (hands-off)
You have a conversation, approve a plan, then walk away.

```
/vision      → guided conversation → writes VISION.md → you approve it
/kickoff     → reads VISION.md → drafts architecture plan → YOU APPROVE
             → autonomous loop: plan → implement → review → checkpoint
             → pauses at each milestone for a quick "continue?" from you
```

**The key approval gate:** After `/kickoff` drafts the milestone plan but
before any code is written, you review it. This is where you catch
"that's not what I meant" — not after a week of wrong code.

**Milestone checkpoints:** At the end of each milestone, the manager
reports what was built and asks if you want to continue. You're not
watching every file get written, just reviewing phase outputs.

### Hands-on (session-by-session)
For when you're actively involved and want finer control.

```
/start-session   → reads all docs, orients you, asks what to focus on
/end-session     → saves state: what's done, what's next, blockers
/add-milestone   → inserts a new milestone and creates its GitHub issues
```

You can mix modes: start with `/kickoff` for the first few milestones,
then switch to hands-on when you want to steer more carefully.

---

## The four documents

These live in the managed project root and are the system's memory.

| File | What it holds | How often it changes |
|------|--------------|----------------------|
| `VISION.md` | Goals, non-goals, principles, tech constraints, architecture | Rarely |
| `MILESTONES.md` | Major phases, tasks, acceptance criteria, status | Per phase |
| `STATUS.md` | In-progress work, next up, blockers, key context | Per session |
| `DECISIONS.md` | Architectural decisions with context and rationale | Append-only |

**STATUS.md is the most important one.** It's the handoff document that
lets you pick up exactly where you left off after any gap.

---

## Setup

### Install the plugin (once)

```
/plugin marketplace add kpanko/software-manager
/plugin install software-manager
```

Restart Claude Code if the new skills don't appear in the `/` menu.

#### Migrating from the old install.sh

If you previously installed via `install.sh`, remove the leftover
command files from Git Bash:

```bash
rm ~/.claude/commands/{vision,kickoff,start-session,end-session,add-milestone,create-issue,setup-github}.md
```

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

---

## GitHub integration (optional)

When a project has a GitHub repo, the system can use issues and a project
board as the task layer instead of just MILESTONES.md.

### Why bother

- Issues outlive context resets — a task filed to the backlog can be picked
  up by an agent in a future session without re-explaining what it is
- Each issue body is the implementation plan the agent works from
- PRs reference and close issues automatically
- The project board gives a visual overview without opening a code editor

### Setup (once per project)

```bash
# After creating the repo, in the project directory:
/setup-github
```

This creates the labels (`cc-generated`, `backlog`, `in-progress`, `blocked`,
`ready-for-pr`) and a GitHub Project board, then writes the config to GITHUB.md.

### How it fits the workflow

```
/kickoff (phase 1 approval)
  → creates GitHub issues for every planned task
  → adds them all to the project board as backlog

/kickoff (phase 2 execution)
  → moves issues to in-progress as work begins
  → agents open PRs with "closes #N" in the body
  → issues auto-close when PRs merge

/create-issue
  → file a task to the backlog without implementing it now
  → use this when you think of something mid-session you don't want to lose
```

### Without GitHub

Everything still works — `/kickoff` just tracks state in MILESTONES.md and
STATUS.md instead. GitHub integration is purely additive.

---

## Realistic expectations

The quality of the output depends on the quality of VISION.md. A vague
vision produces a plausible-sounding architecture plan that may not match
what you actually wanted. The `/vision` command is designed to pull out
enough detail to avoid this — but the more specific you are in that
conversation, the better.

Things that work well autonomously:
- Projects with clear requirements and standard patterns (CRUD apps,
  CLI tools, data pipelines, API integrations)
- Milestones where "done" has an objective definition

Things that need more user involvement:
- Projects where the design is the hard part (novel algorithms, UX-heavy
  interfaces)
- Anything requiring external credentials or services to be set up
- Decisions that depend on your personal taste

---

## Commands reference

| Command | When to use |
|---------|-------------|
| `/setup-project` | Starting a new managed project — copies scaffolding templates into the current directory |
| `/vision` | Starting a new project — generates VISION.md |
| `/kickoff` | Ready to build — plans and executes autonomously |
| `/start-session` | Beginning a hands-on session |
| `/end-session` | Ending a hands-on session |
| `/add-milestone` | Insert a new milestone at any position mid-project |
| `/setup-github` | One-time GitHub labels + project board setup |
| `/create-issue` | File a task to the backlog without implementing it |
