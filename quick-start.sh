#!/bin/bash
# Quick Start: Parallel Component Development
# Run this in Claude Code to see the workflow in action

cat << 'EOF'

╔══════════════════════════════════════════════════════════════════════╗
║     PARALLEL COMPONENT DEVELOPMENT WITH CLAUDE CODE TEAMS           ║
╚══════════════════════════════════════════════════════════════════════╝

This guide shows you how to:
  ✓ Build 5 components in parallel
  ✓ Use specialized agents for each phase
  ✓ Create independent PRs for each component
  ✓ Share context across team members

┌──────────────────────────────────────────────────────────────────────┐
│ STEP 1: Tell me what you want to build                               │
└──────────────────────────────────────────────────────────────────────┘

Say to me:

  "I want to build 5 React components:
   1. UserCard - displays user profile with avatar and info
   2. NavigationBar - responsive nav with dropdowns
   3. DataTable - sortable table with pagination
   4. FormField - reusable input with validation
   5. ModalDialog - accessible modal with animations

   Each component needs:
   - Planning phase
   - Implementation
   - Design review (matches my Figma)
   - Quality check (SonarQube rules)
   - Testing (unit + integration)
   - Separate PR per component"

┌──────────────────────────────────────────────────────────────────────┐
│ STEP 2: I'll create the task list                                    │
└──────────────────────────────────────────────────────────────────────┘

I'll use TaskCreate to create 5 detailed tasks with:
  - Requirements
  - Acceptance criteria
  - Design specifications
  - Technical requirements

┌──────────────────────────────────────────────────────────────────────┐
│ STEP 3: I'll spawn 5 parallel teams                                  │
└──────────────────────────────────────────────────────────────────────┘

For EACH component, I'll create a team with 5 specialized agents:

  component-team-1 (UserCard)
    ├── planner (Plan agent)
    ├── implementer (general-purpose)
    ├── design-reviewer (Explore + web-component skill)
    ├── qa-checker (general-purpose + SonarQube)
    └── tester (general-purpose)

  component-team-2 (NavigationBar)
    └── [same structure]

  [repeat for teams 3-5]

All 25 agents work in parallel! 🚀

┌──────────────────────────────────────────────────────────────────────┐
│ STEP 4: Execute the pipeline                                        │
└──────────────────────────────────────────────────────────────────────┘

I'll coordinate all teams through the pipeline:

  PHASE 1: Planning (parallel)
    ├─ Team 1 planner creates plan → I approve
    ├─ Team 2 planner creates plan → I approve
    ├─ Team 3 planner creates plan → I approve
    ├─ Team 4 planner creates plan → I approve
    └─ Team 5 planner creates plan → I approve

  PHASE 2: Implementation (parallel)
    ├─ Team 1 implementer writes code
    ├─ Team 2 implementer writes code
    ├─ Team 3 implementer writes code
    ├─ Team 4 implementer writes code
    └─ Team 5 implementer writes code

  PHASE 3: Design Review (parallel)
    ├─ Team 1 reviewer checks design match
    ├─ Team 2 reviewer checks design match
    ├─ Team 3 reviewer checks design match
    ├─ Team 4 reviewer checks design match
    └─ Team 5 reviewer checks design match

  PHASE 4: Quality Check (parallel)
    ├─ Team 1 QA runs SonarQube
    ├─ Team 2 QA runs SonarQube
    ├─ Team 3 QA runs SonarQube
    ├─ Team 4 QA runs SonarQube
    └─ Team 5 QA runs SonarQube

  PHASE 5: Testing (parallel)
    ├─ Team 1 tester writes tests
    ├─ Team 2 tester writes tests
    ├─ Team 3 tester writes tests
    ├─ Team 4 tester writes tests
    └─ Team 5 tester writes tests

┌──────────────────────────────────────────────────────────────────────┐
│ STEP 5: Create PRs                                                   │
└──────────────────────────────────────────────────────────────────────┘

Each team creates their own PR:

  Team 1: git checkout -b component/usercard-comp-1
  Team 2: git checkout -b component/navbar-comp-2
  Team 3: git checkout -b component/datatable-comp-3
  Team 4: git checkout -b component/formfield-comp-4
  Team 5: git checkout -b component/modal-comp-5

Each PR includes:
  ✓ Component code
  ✓ Unit tests
  ✓ Integration tests
  ✓ Design verification report
  ✓ Quality check results

┌──────────────────────────────────────────────────────────────────────┐
│ KEY BENEFITS                                                         │
└──────────────────────────────────────────────────────────────────────┘

  ⚡ 5x Faster: Parallel development instead of sequential
  🎯 Specialized: Each agent focuses on their expertise
  🔄 Shared Context: Team members coordinate via task list
  ✅ Quality Gates: Design review + SonarQube + testing
  🌳 Clean Git: Independent branches and PRs
  📊 Scalable: Add more teams/components easily

┌──────────────────────────────────────────────────────────────────────┐
│ READY TO START?                                                      │
└──────────────────────────────────────────────────────────────────────┘

Just tell me:
  "Create 5 React component teams and start parallel development"

I'll handle the rest! 🎉

EOF
