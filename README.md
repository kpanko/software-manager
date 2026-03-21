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
/plan-milestone  → uses planning agent to break down next milestone
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

### Install the slash commands (once)

```bash
bash install.sh
```

This copies the commands into `~/.claude/commands/` so they're available
in any Claude Code project.

### Start a new managed project

```bash
# In the new project directory:
cp /path/to/software-manager/templates/VISION.md .
cp /path/to/software-manager/templates/MILESTONES.md .
cp /path/to/software-manager/templates/STATUS.md .
cp /path/to/software-manager/templates/DECISIONS.md .
cp /path/to/software-manager/templates/project-CLAUDE.md CLAUDE.md
```

Then open Claude Code in that directory and run `/vision`.

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
| `/vision` | Starting a new project — generates VISION.md |
| `/kickoff` | Ready to build — plans and executes autonomously |
| `/start-session` | Beginning a hands-on session |
| `/end-session` | Ending a hands-on session |
| `/plan-milestone` | Manually planning the next milestone |
