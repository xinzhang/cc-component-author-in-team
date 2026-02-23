# Claude Code: Parallel Component Development Example
# This shows the exact workflow you would run in Claude Code

# ============================================================================
# PREPARATION: Define Your Components
# ============================================================================

# Assume you have these 5 components to build:
COMPONENTS=(
  "UserCard:User profile card with avatar, name, email"
  "NavigationBar:Responsive nav with dropdown menus"
  "DataTable:Sortable table with pagination"
  "FormField:Reusable form input with validation"
  "ModalDialog:Accessible modal with animations"
)

# ============================================================================
# STEP 1: Create the Task List
# ============================================================================

# In Claude Code, you would say:
# "Create a task list for building 5 React/Next.js components"
#
# Then use TaskCreate for each component:

# TaskCreate: "UserCard Component"
#   Subject: "Build UserCard component"
#   Description: |
#     Create a UserCard component that displays user profile information.
#     Requirements:
#     - Display user avatar (circular, 64px)
#     - Show full name (bold, heading)
#     - Show email address (secondary text)
#     - Hover effect: slight elevation
#     - Responsive: works on mobile and desktop
#     - Accessible: proper ARIA labels
#     Acceptance Criteria:
#     - Matches Figma design spec
#     - Passes SonarQube quality gate
#     - Unit test coverage > 80%
#     - Storybook story created

# Repeat for all 5 components...

# ============================================================================
# STEP 2: Create the Teams
# ============================================================================

# In Claude Code, create 5 teams (one per component):

TeamCreate team_name="component-team-1" description="UserCard component development"
TeamCreate team_name="component-team-2" description="NavigationBar component development"
TeamCreate team_name="component-team-3" description="DataTable component development"
TeamCreate team_name="component-team-4" description="FormField component development"
TeamCreate team_name="component-team-5" description="ModalDialog component development"

# ============================================================================
# STEP 3: Spawn Team Members (in Parallel)
# ============================================================================

# For EACH team, spawn 5 specialized agents using the Task tool:
# NOTE: You can spawn all 25 agents (5 teams × 5 agents) in one message!

# Example for component-team-1:
Task subagent_type="Plan" team_name="component-team-1" name="planner" \
  description="Plan UserCard implementation"

Task subagent_type="general-purpose" team_name="component-team-1" name="implementer" \
  description="Implement UserCard component"

Task subagent_type="Explore" team_name="component-team-1" name="design-reviewer" \
  description="Review design compliance for UserCard"

Task subagent_type="general-purpose" team_name="component-team-1" name="qa-checker" \
  description="Check SonarQube quality for UserCard"

Task subagent_type="general-purpose" team_name="component-team-1" name="tester" \
  description="Write tests for UserCard"

# Repeat for teams 2-5... (all in parallel!)

# ============================================================================
# STEP 4: Assign Tasks to Teams
# ============================================================================

# Use TaskUpdate to assign each component task to a team:

TaskUpdate taskId="task-1" owner="component-team-1"  # UserCard
TaskUpdate taskId="task-2" owner="component-team-2"  # NavigationBar
TaskUpdate taskId="task-3" owner="component-team-3"  # DataTable
TaskUpdate taskId="task-4" owner="component-team-4"  # FormField
TaskUpdate taskId="task-5" owner="component-team-5"  # ModalDialog

# ============================================================================
# STEP 5: Orchestrate the Workflow
# ============================================================================

# As the team lead, you coordinate each team through SendMessage:

# PHASE 1: PLANNING (all teams in parallel)
SendMessage type="broadcast" content="All teams: Start planning phase. Analyze your requirements and create implementation plans."

# Each team's planner agent creates a detailed plan
# They use ExitPlanMode when ready for approval
# You approve all 5 plans in parallel

# PHASE 2: IMPLEMENTATION (all teams in parallel)
SendMessage type="broadcast" content="All teams: Plans approved. Start implementation phase."

# Each team's implementer agent writes the code
# They share progress via team task list

# PHASE 3: DESIGN REVIEW (all teams in parallel)
SendMessage type="broadcast" content="All teams: Implementation done. Start design review phase."

# Each team's design-reviewer agent:
# - Uses the web-component skill
# - Compares implementation against design specs
# - Uses mcp__zai-mcp-server__ui_diff_check if screenshots available
# - Provides feedback to implementer

# PHASE 4: QUALITY CHECK (all teams in parallel)
SendMessage type="broadcast" content="All teams: Design approved. Start quality check phase."

# Each team's qa-checker agent:
# - Runs SonarQube rules locally or via API
# - Checks code coverage
# - Validates against best practices
# - Reports issues to implementer

# PHASE 5: TESTING (all teams in parallel)
SendMessage type="broadcast" content="All teams: Quality passed. Start testing phase."

# Each team's tester agent:
# - Writes unit tests (Jest/Vitest)
# - Writes integration tests
# - Tests accessibility (axe-core)
# - Validates all acceptance criteria

# ============================================================================
# STEP 6: Git Workflow (Per Team)
# ============================================================================

# When a team completes all phases, they create their PR:

# Example for component-team-1:
SendMessage type="message" recipient="component-team-1" \
  content="All phases complete. Create git branch and PR."

# The team's implementer agent:
# 1. Creates branch: git checkout -b component/usercard-comp-1
# 2. Commits with conventional commit format
# 3. Pushes: git push -u origin component/usercard-comp-1
# 4. Creates PR: gh pr create --title "feat: UserCard component" --body "..."

# ============================================================================
# STEP 7: Monitor and Coordinate
# ============================================================================

# As team lead, you:
# - Monitor progress: TaskList (shows all 5 teams' progress)
# - Handle blockers: SendMessage to specific teams
# - Share learnings: broadcast discoveries between teams
# - Approve phases: ExitPlanMode for planning

# ============================================================================
# STEP 8: Completion
# ============================================================================

# When all 5 teams complete:
# - You have 5 independent PRs
# - Each with full test coverage
# - Each with design and quality verification
# - Ready for final review and merge

# ============================================================================
# KEY INSIGHTS
# ============================================================================

# 1. PARALLEL EXECUTION
#    - All 5 teams work simultaneously
#    - 5x faster than sequential development

# 2. SHARED CONTEXT
#    - Each team has a task list (shared via TeamCreate)
#    - Team members see each other's progress
#    - Use TaskUpdate to mark phases complete

# 3. SPECIALIZED AGENTS
#    - Planner: Plan agent (good at strategy)
#    - Implementer: general-purpose (can write code)
#    - Design Reviewer: Explore + web-component skill
#    - QA Checker: general-purpose + SonarQube knowledge
#    - Tester: general-purpose (test frameworks)

# 4. COMMUNICATION
#    - Use SendMessage for team coordination
#    - Broadcast for all teams
#    - Message for specific teams
#    - Automatic message delivery between teammates

# 5. INDEPENDENT GIT WORKFLOW
#    - Each team owns their branch
#    - Clean git history
#    - Easy code review
#    - Independent merge decisions
