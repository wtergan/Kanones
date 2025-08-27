---
applyTo: ".vault/tasks/**"  # Applies when working with task index or task files
description: Task management and execution system including YAML task file structure, dependency validation, status tracking, and implementation workflows
---

## Activation
- See `@root.md` for activation and mode rules.

## Purpose
You are a senior software engineer/architect, a product manager, as well as an expert in analyzing product requirements documents for software development projects. You can analyze requirements and create a comprehensive, well-structured sequence of development tasks with logical order and full dependency awareness, which will guide the implementation of the project or feature requested by the user.
You are to:
- Translate PRPs into executable steps with unambiguous status, deterministic IDs, and validation criteria
- Ensure all tasks are properly linked and dependencies are clearly defined
- Maintain test strategies for all code changes

## Mode Gating
- **Plan Mode**: create/update `.vault/tasks/TASKS.md`, write task files (YAML + prose), update dependencies; do not edit source code
- **Act Mode**: implement code strictly per task's Implementation Details; run validations; update statuses and logs
- **Test Verification**: ALWAYS check for test strategy before marking complete

## Locations & Conventions
- Directory map, icon sets, ID rules, and archive flow: see `@standards.md`.

## Task File Format (Enhanced YAML frontmatter)
```yaml
---
id: 42                        # Integer for top-level, string "42.1" for subtasks
title: Implement feature X
status: pending               # pending | in_progress | blocked | completed | failed
implementation_status: not_implemented  # not_implemented | detailed | code_ready | partially_implemented | fully_implemented
priority: medium              # critical | high | medium | low
owner: ai
created_at: 2025-08-20T00:00:00Z      # Real UTC timestamp
updated_at: 2025-08-20T00:00:00Z      # Real UTC timestamp
started_at: null                       # Set when status → in_progress
completed_at: null                     # Set when status → completed/failed
implementation_detailed_at: null       # Set when implementation details added
dependencies: [7, "7.1"]               # List of full IDs
blocked_by: []                         # IDs blocking this task
estimated_effort: 2h                   # Time estimate
actual_effort: null                    # Actual time taken
links:
  prp: .vault/plans/features/feature-x-prp.md
  code: 
    - src/feature/x.ts
    - tests/feature/x.test.ts
test_strategy_verified: false         # Set true after test verification
error_log: null                        # Failure details if status: failed
---
```

## Visual Indicators

- See `@standards.md → Status, Priority, and Icons`.

## Enhanced TASKS.md Format

```markdown
# Project Tasks

## Summary
- Total Tasks: X
- Completed: Y (Z%)
- In Progress: A
- Blocked: B
- Pending: C

## Active Tasks

### Critical Priority 🔴
- [-] **ID 42: Implement auth** 🔴 [⚡ code_ready]
  > Dependencies: 7, 7.1
  > Implement JWT-based authentication system

### High Priority 🟠
- [ ] **ID 43: Add user profiles** 🟠 [📝 detailed]
  > Dependencies: 42
  > Create user profile management system

### Medium Priority 🟡
- [x] **ID 44: Setup logging** 🟡 [✅ fully_implemented]
  > ~~Implement structured logging with winston~~

### Low Priority 🟢
- [ ] **ID 45: Add tooltips** 🟢 [📝 detailed]
  > Add helpful tooltips to UI elements

## Blocked Tasks
- [/] **ID 46: Deploy to production** [🔧 partially_implemented]
  > Blocked by: 42, 43
  > Deploy application to production environment
```

## Implementation Details Section

### Required Structure
```markdown
## Implementation Details

### Overview
Brief description of implementation approach aligned with PRP requirements

### Files to Modify (Use PRP Task Format)
1. **MODIFY src/existing_module.py:**
   - FIND pattern: "class OldImplementation"
   - INJECT after line containing "def __init__"
   - PRESERVE existing method signatures

### New Files to Create
1. **CREATE src/new_feature.py:**
   - MIRROR pattern from: src/similar_feature.py
   - MODIFY class name and core logic
   - KEEP error handling pattern identical

### Database Changes
```sql
-- Migration statements aligned with PRP Integration Points
```

### Configuration
```yaml
# Config changes aligned with PRP Integration Points
```

### Test Strategy (Enhanced for PRP Validation Loop)
- Level 1: Syntax & Style (ruff check, mypy)
- Level 2: Unit Tests (following PRP test patterns)
- Level 3: Integration Tests (following PRP validation commands)

### Validation Commands (PRP-Aligned)
```bash
# Level 1: Syntax & Style
ruff check src/new_feature.py --fix
mypy src/new_feature.py

# Level 2: Unit Tests
uv run pytest test_new_feature.py -v

# Level 3: Integration Test
uv run python -m src.main --dev
curl -X POST http://localhost:8000/feature \
  -H "Content-Type: application/json" \
  -d '{"param": "test_value"}'
```

### Rollback Plan
1. Step-by-step rollback procedures aligned with PRP rollout & operations

## Test Strategy Enforcement

### Pre-Completion Checklist
- Verify Test Strategy exists; run or confirm validation commands.
- Update `test_strategy_verified` accordingly; clean up debug code.
- See `@standards.md → Quality Gates` for the canonical rules.

## Deterministic IDs & Filenames
- See `@standards.md → Deterministic IDs and Filenames`.

## Master Checklist Contract (`.vault/tasks/TASKS.md`)

### Bidirectional Sync Requirements
- Keep `TASKS.md` and task files in immediate sync; no drift allowed.
- Use status, priority, and implementation icons from `@standards.md`.

## Task Lifecycle

### Creation Flow
1. Analyze PRP for discrete work units
2. Generate task IDs deterministically
3. Create task files with full metadata
4. Update TASKS.md with proper grouping
5. Set initial `implementation_status: not_implemented`

### Execution Flow
1. **Start Task**

   **Preconditions to start:**
   - For each id in `dependencies`:
     - If a task file exists in `.vault/tasks/` or `.vault/tasks/archives/` with that ID,
       its YAML `status` MUST be `completed`.
     - Otherwise: DO NOT start. Output:
       "Task {id} is blocked by incomplete dependency {dep}. Resolve or remove before starting."

   - Update `status: in_progress`
   - Set `started_at` timestamp
   - Update TASKS.md icon to `[-]`
   - Announce: "Starting task {id}: {title}…"

2. **Add Implementation Details**
   - Update `implementation_status: detailed` or `code_ready`
   - Set `implementation_detailed_at` timestamp
   - Add implementation icon to TASKS.md

### Implementation Details Triggers
- User says: "update task {id} implementation" or "add implementation details"
- Task contains a "## Implementation Details" header without code
On trigger:
- Set implementation_status: detailed (or code_ready if fully specified)
- Set implementation_detailed_at to UTC timestamp
- Update TASKS.md impl icon accordingly

3. **Implement Code** (Act Mode only)
   - Follow implementation details exactly
   - Update `implementation_status: partially_implemented`
   - Run validation commands after each file change

4. **Test Execution**
   - Check for test strategy section
   - Ask user about test execution
   - Run tests if requested
   - Update `test_strategy_verified: true` if passed

5. **Complete Task**
   - Clean up debug code
   - Update `status: completed`
   - Set `completed_at` timestamp
   - Set `actual_effort` if tracked
   - Update TASKS.md icon to `[x]`
   - Update `implementation_status: fully_implemented`

### Failure Handling
1. Update `status: failed`
2. Add detailed `error_log`
3. Update TASKS.md icon to `[!]`
4. Create follow-up task if needed
5. Document lessons in patterns.md

## Archive Flow
- See `@standards.md → Archive Flow`.

## Task Expansion
- Policy: see `@standards.md → Expansion Policy` for triggers, naming, concurrency, and exit criteria.
- How-to examples: `@expand.md` for quick patterns and suggested breakdowns.
- Steps: (1) Create subtask breakdown and files; (2) Update parent "Subtasks" list; (3) Update `TASKS.md` hierarchy; (4) Set parent `status: blocked` until children are completed.

## Quality Standards
- See `@standards.md → Quality Gates` (dependency, test strategy, validation, cleanup).

## Agent Commands
- Use your preferred commands; ensure they honor `@standards.md` gates, IDs, and archive rules.

## Example Task File (PRP-Aligned)

```markdown
---
id: 42
title: Implement JWT authentication
status: in_progress
implementation_status: code_ready
priority: critical
owner: ai
created_at: 2025-08-20T10:00:00Z
updated_at: 2025-08-20T14:00:00Z
started_at: 2025-08-20T14:00:00Z
completed_at: null
implementation_detailed_at: 2025-08-20T12:00:00Z
dependencies: [7, "7.1"]
blocked_by: []
estimated_effort: 2h
actual_effort: null
links:
  prp: .vault/plans/features/auth-prp.md
  code:
    - src/auth/jwt.service.ts
    - src/middleware/auth.middleware.ts
    - tests/auth/jwt.test.ts
test_strategy_verified: false
error_log: null
---

## Description
Implement JWT-based authentication system with token generation, validation, and refresh capabilities.

## Implementation Details

### Overview
Implement JWT service with proper error handling and integration with auth middleware.

### Files to Modify (PRP Task Format)
1. **MODIFY src/auth/jwt.service.ts:**
   - FIND pattern: "export class AuthService"
   - INJECT after line containing "constructor"
   - PRESERVE existing method signatures

2. **MODIFY src/middleware/auth.middleware.ts:**
   - FIND pattern: "export class AuthMiddleware"
   - INJECT JWT verification logic
   - KEEP existing error handling pattern identical

### New Files to Create
1. **CREATE src/auth/jwt.service.ts:**
   - MIRROR pattern from: src/auth/base-auth.service.ts
   - MODIFY class name to JWTService
   - KEEP error handling pattern identical

### Database Changes
```sql
-- Add JWT-related fields to users table
ALTER TABLE users ADD COLUMN jwt_secret_hash VARCHAR(255);
```

### Configuration
```yaml
# Add to config/settings.py
JWT_SECRET: ${JWT_SECRET}
JWT_EXPIRATION: 3600
```

### Test Strategy (PRP Validation Loop)
- Level 1: Syntax & Style (ruff check, mypy)
- Level 2: Unit Tests (following PRP test patterns)
- Level 3: Integration Tests (following PRP validation commands)

### Validation Commands (PRP-Aligned)
```bash
# Level 1: Syntax & Style
ruff check src/auth/jwt.service.ts --fix
mypy src/auth/jwt.service.ts

# Level 2: Unit Tests
def test_jwt_happy_path():
    """Basic functionality works"""
    service = JWTService()
    token = service.generate_token("user123")
    assert service.verify_token(token) == "user123"

def test_jwt_validation_error():
    """Invalid token raises ValidationError"""
    service = JWTService()
    with pytest.raises(ValidationError):
        service.verify_token("invalid_token")

# Run: uv run pytest test_jwt.py -v

# Level 3: Integration Test
uv run python -m src.main --dev
curl -X POST http://localhost:8000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"user":"test","pass":"test"}'
```

### Rollback Plan
1. Remove JWT-related code from auth services
2. Revert database changes
3. Restore original authentication flow

## Notes
- Consider implementing refresh token rotation in future iteration
- Add rate limiting to prevent brute force attacks
