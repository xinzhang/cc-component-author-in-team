# Team Communication & Coordination Flow

## How Team Members Coordinate

Each team has 5 agents that need to coordinate. Here's how they communicate:

```
┌─────────────────────────────────────────────────────────────────────┐
│                        TEAM LEAD (You)                              │
│                  Coordinates all 5 teams                            │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              │ broadcasts
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    Broadcast Message Flow                           │
│  "All teams: Start planning phase"                                  │
└─────────────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│ component-1   │     │ component-2   │     │ component-3   │
│ UserCard      │     │ NavigationBar │     │ DataTable     │
└───────────────┘     └───────────────┘     └───────────────┘
        │
        │ Internal team communication
        ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      component-team-1                               │
│  Task List: [UserCard] status: in_progress                          │
└─────────────────────────────────────────────────────────────────────┘
        │
        ├─ planner (Plan agent)
        │    │
        │    ├─ Creates implementation plan
        │    ├─ Calls ExitPlanMode (asks lead for approval)
        │    └─ Waits for lead approval
        │
        ├─ implementer (general-purpose)
        │    │
        │    ├─ Receives plan approval
        │    ├─ Writes React/Next.js code
        │    ├─ Updates task: "Implementation complete"
        │    └─ Notifies reviewer via SendMessage
        │
        ├─ design-reviewer (Explore + web-component skill)
        │    │
        │    ├─ Receives "implementation complete" message
        │    ├─ Checks against design specs
        │    ├─ Uses web-component skill for patterns
        │    ├─ Sends feedback to implementer if needed
        │    └─ Updates task: "Design approved"
        │
        ├─ qa-checker (general-purpose + SonarQube)
        │    │
        │    ├─ Receives "design approved" message
        │    ├─ Runs SonarQube checks
        │    ├─ Reports issues to implementer
        │    └─ Updates task: "Quality check passed"
        │
        └─ tester (general-purpose)
             │
             ├─ Receives "quality passed" message
             ├─ Writes unit tests (Jest/Vitest)
             ├─ Writes integration tests
             ├─ Validates acceptance criteria
             ├─ Updates task: "Testing complete"
             └─ Notifies team lead
```

## Message Flow Examples

### Example 1: Team Lead Broadcasts to All Teams

**You (Team Lead):**
```
SendMessage type="broadcast"
  content="All teams: Move to implementation phase"
```

**Result:** All 5 teams receive the message simultaneously

### Example 2: Team Member Coordinates Within Team

**design-reviewer (component-team-1):**
```
SendMessage type="message" recipient="implementer"
  content="Design review complete. Found 2 issues:
  1. Avatar size is 60px, should be 64px per spec
  2. Missing ARIA label on user info section
  Please fix and I'll re-review."
```

**Result:** implementer receives the message and fixes the issues

### Example 3: Team Lead Coordinates Specific Team

**You (Team Lead):**
```
SendMessage type="message" recipient="component-team-1"
  content="UserCard team: You're blocking component-team-2 (NavigationBar)
  because they need your avatar component. Please prioritize."
```

**Result:** component-team-1 adjusts priorities

### Example 4: Team Member Reports Completion

**tester (component-team-1):**
```
SendMessage type="message" recipient="planner"
  content="Testing complete. All acceptance criteria validated.
  Ready for PR creation."
```

**planner (component-team-1):**
```
SendMessage type="message" recipient="implementer"
  content="All phases complete. Please create git branch and PR."
```

## Task List Coordination

Each team has a shared task list. All team members can see and update it:

```
Task: UserCard Component
  Status: in_progress
  Owner: component-team-1
  BlockedBy: []

  Progress:
  [✓] Planning (planner)
  [✓] Implementation (implementer)
  [✓] Design Review (design-reviewer)
  [✓] Quality Check (qa-checker)
  [→] Testing (tester) - IN PROGRESS
  [ ] PR Creation (pending)

  Comments:
  - "Design review found 2 minor issues, fixed" - design-reviewer
  - "SonarQube: 0 issues, coverage 92%" - qa-checker
  - "Writing unit tests now, ETA 5 min" - tester
```

## Benefits of This Architecture

### 1. **Parallel Execution**
- 5 teams work simultaneously
- No waiting between components
- 5x faster than sequential

### 2. **Shared Context**
- Task list shows progress
- Comments share discoveries
- Everyone sees blockers

### 3. **Specialized Roles**
- Planner: Strategy and architecture
- Implementer: Code writing
- Reviewer: Quality validation
- QA: Standards compliance
- Tester: Test coverage

### 4. **Clear Communication**
- Broadcast: All teams
- Message: Specific team/member
- Automatic delivery
- No polling needed

### 5. **Independent Workflows**
- Each team owns their git branch
- Independent PRs
- Clean history
- Easy review

## Real-World Example Session

```bash
# You start by creating the teams
TeamCreate team_name="component-team-1" description="UserCard component"
TeamCreate team_name="component-team-2" description="NavigationBar component"
# ... create 3 more teams

# You spawn team members (all 25 agents in parallel)
Task subagent_type="Plan" team_name="component-team-1" name="planner" ...
Task subagent_type="general-purpose" team_name="component-team-1" name="implementer" ...
# ... spawn all agents

# You assign tasks
TaskUpdate taskId="1" owner="component-team-1"
TaskUpdate taskId="2" owner="component-team-2"
# ... assign all tasks

# You broadcast phase transitions
SendMessage type="broadcast" content="All teams: Start planning phase"
SendMessage type="broadcast" content="All teams: Plans approved, start implementation"
SendMessage type="broadcast" content="All teams: Start design review"
SendMessage type="broadcast" content="All teams: Start quality check"
SendMessage type="broadcast" content="All teams: Start testing"

# You monitor progress
TaskList  # Shows all 5 teams' progress

# You handle issues
SendMessage type="message" recipient="component-team-3"
  content="DataTable team: You're blocking on the FormField component.
  component-team-4 is delayed. Should we adjust dependencies?"

# Teams create PRs independently
# Each team's implementer creates their branch and PR

# You review and merge
gh pr list  # Shows 5 independent PRs
```

This architecture gives you maximum parallelism while maintaining coordination and quality!
