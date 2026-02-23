# Parallel Component Development with Claude Code Teams

## Overview

This guide shows you how to build **5 React/Next.js components in parallel** using Claude Code's team features, with each component going through a complete lifecycle:

```
Plan → Implement → Design Review → Quality Check → Test → PR
```

## What You'll Achieve

- ✅ **5x faster development** - All components built simultaneously
- ✅ **Specialized agents** - Each phase handled by expert subagents
- ✅ **Quality gates** - Design review + SonarQube + testing
- ✅ **Independent PRs** - Clean git history per component
- ✅ **Shared context** - Team members coordinate via task list

## Quick Start

1. **Read the architecture** - `ARCHITECTURE.md`
2. **Understand the workflow** - `IMPLEMENTATION_GUIDE.md`
3. **See example session** - `EXAMPLE_SESSION.sh`
4. **Learn communication** - `COMMUNICATION_FLOW.md`
5. **Run the demo** - `./quick-start.sh`

## Key Concepts

### Teams

A **team** is a group of agents working together on a specific task. Each team has:
- A shared task list
- Multiple specialized agents
- Internal communication
- Independent git workflow

### Agents

An **agent** is an AI subprocess with specific capabilities:

| Agent Type | Subagent Type | Role |
|------------|---------------|------|
| Planner | `Plan` | Creates implementation strategy |
| Implementer | `general-purpose` | Writes React/Next.js code |
| Design Reviewer | `Explore` + web-component skill | Validates design match |
| QA Checker | `general-purpose` | Runs SonarQube checks |
| Tester | `general-purpose` | Writes tests |

### Task List

A **task list** tracks progress across all team members:
- Shows status (pending/in_progress/completed)
- Shows owner (which team)
- Shows blockers (dependencies)
- Stores comments and discoveries

### Communication

**SendMessage** coordinates teams:
- `broadcast` - Send to all teams
- `message` - Send to specific team/member
- Automatic delivery - No polling needed

## Workflow

```
┌─────────────────────────────────────────────────────────────┐
│ 1. CREATE TASK LIST                                         │
│    Use TaskCreate to create 5 component tasks               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. CREATE TEAMS                                             │
│    Use TeamCreate to spawn 5 teams (one per component)      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. SPAWN TEAM MEMBERS                                       │
│    Use Task to spawn 5 agents per team (25 total)           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. ASSIGN TASKS                                             │
│    Use TaskUpdate to assign each component to a team        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. EXECUTE PIPELINE (Parallel)                              │
│    Phase 1: Planning (all teams)                            │
│    Phase 2: Implementation (all teams)                      │
│    Phase 3: Design Review (all teams)                       │
│    Phase 4: Quality Check (all teams)                       │
│    Phase 5: Testing (all teams)                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ 6. CREATE PRs (Per Team)                                    │
│    Each team creates their own branch and PR                │
└─────────────────────────────────────────────────────────────┘
```

## Example Commands

### Create a Team
```bash
TeamCreate team_name="component-team-1" description="UserCard component development"
```

### Spawn Team Members
```bash
Task subagent_type="Plan" team_name="component-team-1" name="planner" \
  description="Plan UserCard implementation"

Task subagent_type="general-purpose" team_name="component-team-1" name="implementer" \
  description="Implement UserCard component"
```

### Assign Task to Team
```bash
TaskUpdate taskId="1" owner="component-team-1"
```

### Coordinate Teams
```bash
# Broadcast to all teams
SendMessage type="broadcast" content="All teams: Start implementation phase"

# Message specific team
SendMessage type="message" recipient="component-team-1" \
  content="Please prioritize avatar component"
```

### Monitor Progress
```bash
TaskList  # Shows all teams and their progress
```

## Team Structure (Per Component)

```
component-team-N (Component Name)
├── planner (Plan agent)
│   └── Creates implementation strategy
├── implementer (general-purpose)
│   └── Writes React/Next.js code
├── design-reviewer (Explore + web-component skill)
│   └── Validates design match
├── qa-checker (general-purpose + SonarQube)
│   └── Checks code quality
└── tester (general-purpose)
    └── Writes tests
```

## Git Workflow (Per Team)

Each team creates their own branch and PR:

```bash
# Team 1
git checkout -b component/usercard-comp-1
git add src/components/UserCard/
git commit -m "feat: UserCard component"
git push -u origin component/usercard-comp-1
gh pr create --title "feat: UserCard component" --body "..."

# Team 2
git checkout -b component/navbar-comp-2
# ... same pattern

# Result: 5 independent PRs
```

## Benefits

| Benefit | Description |
|---------|-------------|
| **5x Faster** | Parallel development vs sequential |
| **Specialized** | Each agent focuses on their expertise |
| **Quality Gates** | Design review + SonarQube + testing |
| **Clean Git** | Independent branches and PRs |
| **Scalable** | Easy to add more teams/components |
| **Shared Context** | Team members see each other's progress |

## Files in This Guide

- **README.md** - This file, overview and quick start
- **ARCHITECTURE.md** - System architecture and design
- **IMPLEMENTATION_GUIDE.md** - Step-by-step implementation
- **EXAMPLE_SESSION.sh** - Real-world example commands
- **COMMUNICATION_FLOW.md** - How teams communicate
- **quick-start.sh** - Interactive quick-start guide

## Getting Started

Run the quick-start guide:

```bash
./quick-start.sh
```

Then tell me what you want to build:

```
"I want to build 5 React components:
 1. UserCard - user profile with avatar
 2. NavigationBar - responsive nav
 3. DataTable - sortable table
 4. FormField - input with validation
 5. ModalDialog - accessible modal

 Each needs: Plan → Implement → Design Review → QA → Test → PR"
```

I'll create the teams, spawn the agents, and coordinate the entire workflow!

## Key Tools Used

| Tool | Purpose |
|------|---------|
| `TeamCreate` | Create a team with task list |
| `Task` | Spawn specialized agents |
| `TaskCreate` | Create component tasks |
| `TaskUpdate` | Assign tasks and update status |
| `TaskList` | Monitor all team progress |
| `SendMessage` | Coordinate team communication |
| `ExitPlanMode` | Approve implementation plans |

## Advanced: Customizing the Workflow

You can customize this architecture for your needs:

### Different Team Sizes
```bash
# Small component: 3 agents
TeamCreate team_name="small-component" ...

# Large component: 7 agents
TeamCreate team_name="large-component" ...
```

### Different Pipeline Stages
```bash
# Add security review
Task subagent_type="general-purpose" name="security-reviewer" ...

# Add performance testing
Task subagent_type="general-purpose" name="perf-tester" ...
```

### Different Agent Types
```bash
# Use Explore for research
Task subagent_type="Explore" name="researcher" ...

# Use Bash for command execution
Task subagent_type="Bash" name="builder" ...
```

## Next Steps

1. ✅ Read all the documentation files
2. ✅ Understand your component requirements
3. ✅ Tell me to create the teams
4. ✅ I'll handle the rest!

---

**Ready to build 5 components in parallel? Just say the word!** 🚀
