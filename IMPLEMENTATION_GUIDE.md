#!/bin/bash
# Parallel Component Development with Claude Code Teams
# This script demonstrates the complete workflow

set -e

# ============================================================================
# STEP 1: Create Task List
# ============================================================================
echo "=== Step 1: Creating Task List ==="

# Create 5 component tasks using TaskCreate
# Each task includes: requirements, acceptance criteria, design specs

# Task 1: UserCard Component
# Task 2: NavigationBar Component
# Task 3: DataTable Component
# Task 4: FormField Component
# Task 5: ModalDialog Component

echo "✓ Tasks created with full requirements and acceptance criteria"

# ============================================================================
# STEP 2: Create Team Structure
# ============================================================================
echo -e "\n=== Step 2: Creating 5 Parallel Teams ==="

# Using TeamCreate to spawn 5 teams
# Each team = one component
# Team names: component-team-1, component-team-2, etc.

echo "✓ 5 teams created"
echo "  - component-team-1 (UserCard)"
echo "  - component-team-2 (NavigationBar)"
echo "  - component-team-3 (DataTable)"
echo "  - component-team-4 (FormField)"
echo "  - component-team-5 (ModalDialog)"

# ============================================================================
# STEP 3: Spawn Team Members (Parallel)
# ============================================================================
echo -e "\n=== Step 3: Spawning Team Members ==="

# For EACH team, spawn specialized agents:
# - planner: Plan agent (creates implementation strategy)
# - implementer: general-purpose (writes code)
# - reviewer: Explore agent (verifies design match)
# - qa: general-purpose (SonarQube quality check)
# - tester: general-purpose (writes tests)

echo "✓ 25 agents spawned (5 per team × 5 teams)"

# ============================================================================
# STEP 4: Execute Pipeline (Parallel Across Teams)
# ============================================================================
echo -e "\n=== Step 4: Executing Development Pipeline ==="

# Each team follows this workflow:
#
# Phase 1: Planning
#   - Planner agent analyzes requirements
#   - Creates detailed implementation plan
#   - Identifies dependencies
#
# Phase 2: Implementation
#   - Implementer agent writes React/Next.js code
#   - Follows team coding standards
#   - Uses web-component skill for patterns
#
# Phase 3: Design Review
#   - Reviewer agent checks against design specs
#   - Uses web-component skill to verify UI match
#   - Validates accessibility and responsiveness
#
# Phase 4: Quality Check
#   - QA agent runs SonarQube rules
#   - Checks code coverage
#   - Validates best practices
#
# Phase 5: Testing
#   - Tester agent writes unit tests (Jest/Vitest)
#   - Writes integration tests
#   - Validates acceptance criteria

echo "✓ All teams executing pipeline in parallel"

# ============================================================================
# STEP 5: Git Branch & PR Creation (Per Team)
# ============================================================================
echo -e "\n=== Step 5: Creating Branches and PRs ==="

# Each team creates their own git workflow:
#   1. Create branch: component/comp-1-usercard
#   2. Commit changes with conventional commits
#   3. Push to remote
#   4. Create PR using gh CLI
#   5. PR includes:
#      - Component description
#      - Test results
#      - Design verification
#      - Quality check results

echo "✓ 5 PRs created:"
echo "  - PR #1: component/comp-1-usercard"
echo "  - PR #2: component/comp-2-navigationbar"
echo "  - PR #3: component/comp-3-datatable"
echo "  - PR #4: component/comp-4-formfield"
echo "  - PR #5: component/comp-5-modaldialog"

# ============================================================================
# Summary
# ============================================================================
echo -e "\n=== Summary ==="
echo "✓ 5 components developed in parallel"
echo "✓ Full lifecycle: Plan → Implement → Review → QA → Test → PR"
echo "✓ Shared context across team members via team task list"
echo "✓ Independent git branches and PRs"
echo "✓ Ready for code review and merge"

# ============================================================================
# Key Benefits
# ============================================================================
echo -e "\n=== Key Benefits ==="
echo "1. Parallel Execution: 5 components built simultaneously"
echo "2. Shared Context: Team members share task list and progress"
echo "3. Specialized Roles: Each agent focuses on their expertise"
echo "4. Quality Gates: Design review + SonarQube + testing"
echo "5. Independent PRs: Clean git history, easy review"
echo "6. Scalable: Can add more teams or agents as needed"
