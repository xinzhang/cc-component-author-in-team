# Parallel Component Development Architecture

## Overview
Build 5 React/Next.js components in parallel with full lifecycle:
Plan → Implement → Review (design match) → Quality Check (SonarQube) → Test → PR

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Team Lead (You)                           │
│  - Creates task list with 5 component tasks                  │
│  - Spawns 5 parallel teams (one per component)               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              Component Teams (5 parallel teams)              │
├─────────────────┬─────────────────┬─────────────────┬───────┤
│  ComponentTeam1  │  ComponentTeam2  │  ComponentTeam3  │  ...  │
└─────────────────┴─────────────────┴─────────────────┴───────┘
        │                       │                       │
        ▼                       ▼                       ▼
┌───────────────┐      ┌───────────────┐      ┌───────────────┐
│ Team Members: │      │ Team Members: │      │ Team Members: │
│ • Planner     │      │ • Planner     │      │ • Planner     │
│ • Implementer │      │ • Implementer │      │ • Implementer │
│ • Reviewer    │      │ • Reviewer    │      │ • Reviewer    │
│ • QA Engineer │      │ • QA Engineer │      │ • QA Engineer │
│ • Tester      │      │ • Tester      │      │ • Tester      │
└───────────────┘      └───────────────┘      └───────────────┘
        │                       │                       │
        ▼                       ▼                       ▼
   Branch: comp-1          Branch: comp-2          Branch: comp-3
   PR: Component 1         PR: Component 2         PR: Component 3
```

## Implementation Steps

### 1. Create Task List
Use `TaskCreate` to create 5 component tasks with dependencies and requirements

### 2. Create Agent Teams
Use `TeamCreate` to spawn 5 parallel teams (one per component)

### 3. Spawn Team Members
Each team gets specialized agents:
- **Planner** (Plan agent) - Analyze requirements, create implementation plan
- **Implementer** (general-purpose) - Write the React/Next.js code
- **DesignReviewer** (Explore + web-component skill) - Verify design match
- **QualityChecker** (general-purpose) - Check against SonarQube rules
- **Tester** (general-purpose) - Write unit/integration tests

### 4. Coordinate Parallel Execution
Each team works independently on their git branch

### 5. Create PRs
Each team creates their own PR when complete
