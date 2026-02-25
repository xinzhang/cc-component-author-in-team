# Audit System Design Analysis

**Date:** 2026-02-25
**Project:** Tasks Table Audit Functionality

---

## Table of Contents

1. [Requirements](#requirements)
2. [Approaches Comparison](#approaches-comparison)
3. [Detailed Analysis](#detailed-analysis)
4. [Final Recommendation](#final-recommendation)
5. [Implementation Schema](#implementation-schema)

---

## Requirements

Based on project analysis, the audit system must support:

### Primary Purposes
- ✅ **User activity tracking** - Track who changed what and when
- ✅ **Compliance & legal requirements** - Immutable logs for regulatory audits
- ✅ **Rollback capability** - Ability to revert changes and restore previous states

### Query Patterns
- **Balanced mix** - Both single record history and cross-record analysis queries are equally important
- Need to query complete history of individual tasks
- Need to see all changes by specific users or in time ranges

### Data Characteristics
- **Volume:** Low (< 1K changes per day)
- **Change size:** Small changes (typically 2-3 fields per update)
- **UI Requirements:** Need both diff view (what changed) and snapshot view (complete state)

---

## Approaches Comparison

### Approach 1: Pure Versioning (Single Table)

Store every change as a new version in the same table with `is_current` flag.

#### Pros
- ✅ Simple schema (single table)
- ✅ Natural rollback support
- ✅ Complete history automatically
- ✅ Temporal queries are straightforward

#### Cons
- ❌ Table grows indefinitely (needs cleanup strategy)
- ❌ Queries get complex (need `WHERE is_current` everywhere)
- ❌ Harder to maintain data integrity (multiple "current" rows possible)
- ❌ Performance degrades as table grows
- ❌ Audit trails can be modified (not truly immutable)

---

### Approach 2: Pure Audit Table (Two Tables)

Keep main `tasks` table lean, store all changes in separate `task_audit` table.

#### Pros
- ✅ Clean separation (current vs historical)
- ✅ Main table stays fast and small
- ✅ Can add indexes optimized for audit queries
- ✅ Easy to make audit table immutable

#### Cons
- ❌ Rollback requires rebuilding state from audit log
- ❌ Complex queries for "what did this task look like at time X?"
- ❌ Need full row snapshots (or complex diff reconstruction)
- ❌ Harder to query current state + history together

---

### Approach 3: Hybrid Approach (Three Tables) ⭐ RECOMMENDED

**Components:**
- Main `tasks` table - Current state only
- `task_versions` table - Last N versions for rollback (configurable, e.g., 10 versions)
- `task_audit_log` table - Immutable records of ALL changes for compliance

#### How it works
```sql
BEGIN;
-- Update current task
UPDATE tasks SET ... WHERE id = X;

-- Create version for rollback
INSERT INTO task_versions (task_id, version, data) VALUES (X, v5, {...});

-- Create immutable audit log
INSERT INTO task_audit_log (task_id, action, changed_at, changed_by, data) VALUES (X, 'update', now(), 'user', {...});
COMMIT;
```

#### Pros
- ✅ Fast rollback (just query versions table)
- ✅ Compliance-friendly (immutable audit log)
- ✅ Efficient queries (separate tables for different use cases)
- ✅ Can archive old audit logs without affecting rollback
- ✅ Clear separation of concerns

#### Cons
- ⚠️ Slight duplication (data in both version and audit tables)
- ⚠️ More complex schema (3 tables instead of 1-2)
- ⚠️ Write overhead (insert to two tables on each update)

---

## Detailed Analysis

### Write Operation Comparison

| Approach | Write Complexity | Transaction Safety |
|----------|-----------------|-------------------|
| Pure Versioning (1 table) | Low - Single INSERT | ⚠️ Risk of multiple "current" rows |
| Pure Audit (2 tables) | Medium - UPDATE + INSERT | ✅ Simple transaction |
| Hybrid (3 tables) | Medium-High - UPDATE + 2 INSERTs | ✅ Simple transaction |

### Query Performance Comparison

| Query Type | Pure Versioning | Pure Audit | Hybrid |
|------------|-----------------|------------|--------|
| Get current state | ⚠️ Needs WHERE filter | ✅ Direct query | ✅ Direct query |
| Get history by task | ⚠️ Self-join needed | ✅ Direct query | ✅ Direct query |
| Rollback to version | ✅ Easy (copy row) | ❌ Complex (rebuild) | ✅ Easy (copy row) |
| Compliance audit | ❌ Can be modified | ✅ Immutable | ✅ Immutable |
| Cross-record analysis | ⚠️ Complex WHERE | ✅ Optimized indexes | ✅ Optimized indexes |

---

## Final Recommendation

### **Recommended: Pure Versioning with Two Tables**

Given the requirements analysis:
- ✅ Need rollback capability (snapshots essential)
- ✅ Need diff view for UI
- ✅ Balanced query patterns
- ✅ Low volume (write overhead not a concern)
- ✅ Small changes per update

**Recommended Schema:**

```sql
-- Main table (current state only)
CREATE TABLE tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50) NOT NULL,
  assignee_id INTEGER,
  priority INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  created_by INTEGER,
  updated_by INTEGER
);

-- Versions table (complete history with snapshots)
CREATE TABLE task_versions (
  id SERIAL PRIMARY KEY,
  task_id INTEGER NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  version_number INTEGER NOT NULL,

  -- Complete snapshot of task state
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50) NOT NULL,
  assignee_id INTEGER,
  priority INTEGER DEFAULT 0,

  -- Metadata
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  changed_by INTEGER,
  change_reason TEXT,

  -- What changed (for diff view)
  changed_fields JSONB,

  -- Constraints
  UNIQUE (task_id, version_number)
);

-- Indexes for performance
CREATE INDEX idx_task_versions_task_id ON task_versions(task_id);
CREATE INDEX idx_task_versions_changed_at ON task_versions(changed_at);
CREATE INDEX idx_task_versions_changed_by ON task_versions(changed_by);

-- Trigger for automatic versioning (optional)
CREATE OR REPLACE FUNCTION create_task_version()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO task_versions (
    task_id,
    version_number,
    title,
    description,
    status,
    assignee_id,
    priority,
    changed_at,
    changed_by,
    changed_fields
  )
  SELECT
    NEW.id,
    COALESCE((SELECT MAX(version_number) FROM task_versions WHERE task_id = NEW.id), 0) + 1,
    NEW.title,
    NEW.description,
    NEW.status,
    NEW.assignee_id,
    NEW.priority,
    NEW.updated_at,
    NEW.updated_by,
    -- Build changed_fields JSON
    CASE
      WHEN OLD IS NULL THEN NULL
      ELSE
        jsonb_build_object(
          'changed', ARRAY[
            CASE WHEN OLD.title != NEW.title THEN 'title' END,
            CASE WHEN OLD.description != NEW.description THEN 'description' END,
            CASE WHEN OLD.status != NEW.status THEN 'status' END,
            CASE WHEN OLD.assignee_id != NEW.assignee_id THEN 'assignee_id' END,
            CASE WHEN OLD.priority != NEW.priority THEN 'priority' END
          ] FILTER (WHERE element IS NOT NULL),
          'old', jsonb_build_object(
            'title', OLD.title,
            'description', OLD.description,
            'status', OLD.status,
            'assignee_id', OLD.assignee_id,
            'priority', OLD.priority
          ),
          'new', jsonb_build_object(
            'title', NEW.title,
            'description', NEW.description,
            'status', NEW.status,
            'assignee_id', NEW.assignee_id,
            'priority', NEW.priority
          )
        )
    END
  FROM (SELECT 1) AS dummy;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER task_version_trigger
AFTER INSERT OR UPDATE ON tasks
FOR EACH ROW
EXECUTE FUNCTION create_task_version();
```

### Key Design Decisions

1. **Two tables (not one):**
   - Main `tasks` table stays lean and fast
   - No need for `WHERE is_current = true` filters
   - Clean separation of concerns

2. **Complete snapshots in versions:**
   - Easy rollback (just copy row back)
   - Simple "state at time X" queries
   - No complex diff reconstruction

3. **`changed_fields` JSONB column:**
   - Efficient diff view in UI
   - Shows exactly what changed (old → new)
   - Optional field for storage optimization

4. **Automatic versioning via trigger:**
   - Can't forget to create version
   - Transaction-safe
   - Minimal application code changes

---

## Common Query Patterns

### Get current task
```sql
SELECT * FROM tasks WHERE id = ?;
```

### Get task history
```sql
SELECT * FROM task_versions
WHERE task_id = ?
ORDER BY version_number DESC;
```

### Rollback to specific version
```sql
-- Get version details
SELECT * FROM task_versions
WHERE task_id = ? AND version_number = ?;

-- Update tasks table with version data
UPDATE tasks
SET title = ?, description = ?, status = ?, assignee_id = ?, priority = ?
WHERE id = ?;
```

### Get diff view (what changed)
```sql
SELECT
  version_number,
  changed_at,
  changed_by,
  changed_fields
FROM task_versions
WHERE task_id = ?
ORDER BY version_number DESC;
```

### Get all changes by user
```sql
SELECT v.*, t.title as task_title
FROM task_versions v
JOIN tasks t ON t.id = v.task_id
WHERE v.changed_by = ?
ORDER BY v.changed_at DESC;
```

### Get state at specific time
```sql
SELECT * FROM task_versions
WHERE task_id = ? AND changed_at <= ?
ORDER BY changed_at DESC
LIMIT 1;
```

---

## Migration Considerations

### For existing tables:

1. **Create versions table first**
2. **Create initial version from current data:**
   ```sql
   INSERT INTO task_versions (task_id, version_number, title, description, status, assignee_id, priority, changed_at, changed_by)
   SELECT id, 1, title, description, status, assignee_id, priority, updated_at, updated_by
   FROM tasks;
   ```
3. **Add trigger for automatic versioning**

---

## Summary

| Aspect | Choice | Rationale |
|--------|--------|-----------|
| **Schema** | Two tables | Clean separation, better performance, simpler queries |
| **Version storage** | Complete snapshots | Easy rollback, no complex reconstruction |
| **Diff tracking** | JSONB `changed_fields` column | Flexible, efficient for UI display |
| **Automation** | Database trigger | Can't forget to version, transaction-safe |
| **Indexes** | `task_id`, `changed_at`, `changed_by` | Optimized for common query patterns |

This design provides:
- ✅ Simple queries for current state
- ✅ Easy rollback capability
- ✅ Efficient diff view
- ✅ User activity tracking
- ✅ Compliance-ready audit trail
- ✅ Performance at low volume

---

*Document generated: 2026-02-25*
*Based on requirements: User tracking, Compliance, Rollback, Balanced queries, Low volume, Small changes*
