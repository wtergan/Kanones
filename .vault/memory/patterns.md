# Patterns & Decisions

## Code Conventions

### Naming (2024-01-15)
- **Pattern**: Use camelCase for variables, PascalCase for classes
- **Rationale**: Consistency with framework standards and JavaScript/TypeScript conventions
- **Example**: `userId`, `taskManager`, `JWTService`

### Error Handling (2024-01-20)
- **Pattern**: Wrap all async operations in try-catch blocks
- **Rationale**: Predictable error propagation and debugging
- **Example**: All API calls and file operations include comprehensive error handling

### Testing (2024-02-01)
- **Pattern**: Test file naming: `{file}.test.ts` with descriptive test names
- **Rationale**: Collocation and easy discovery of test files
- **Enforcement**: Manual validation during task completion
- **Example**: `jwt.service.test.ts`, `task-manager.test.ts`

### Documentation (2024-01-25)
- **Pattern**: All code changes include implementation details in task files
- **Rationale**: Copy-paste ready execution and validation
- **Enforcement**: Required before marking tasks as code_ready
- **Example**: Complete file modifications with FIND/REPLACE blocks

## Architecture Decisions

### State Management (2024-01-10)
- **Decision**: File-based state management with bidirectional sync
- **Rationale**: IDE-agnostic, version controllable, human-readable
- **Alternative Considered**: Database storage (too complex for this use case)
- **Review Date**: 2024-07-01

### Task Dependencies (2024-01-12)
- **Decision**: Mandatory dependency validation before task execution
- **Rationale**: Prevents execution of tasks with unmet prerequisites
- **Alternative Considered**: Optional dependencies (leads to execution failures)
- **Review Date**: 2024-06-01

### Mode Separation (2024-01-08)
- **Decision**: Strict Plan/Act mode separation with keyword triggers
- **Rationale**: Safety, predictability, and clear intent communication
- **Alternative Considered**: Flexible mode switching (leads to confusion)
- **Review Date**: 2024-08-01

### Quality Gates (2024-01-18)
- **Decision**: Multiple quality gates: dependency, test strategy, validation
- **Rationale**: Ensures high-quality output and prevents common failures
- **Alternative Considered**: Single gate approach (misses edge cases)
- **Review Date**: 2024-05-01

## Operational Patterns

### Session Management (2024-02-15)
- **Pattern**: Initialize with vault files, end with sync and handoff notes
- **Rationale**: Context persistence and multi-agent collaboration
- **Implementation**: Standard process in session-lifecycle.mdc

### Archive Strategy (2024-03-01)
- **Pattern**: Archive completed items with timestamps to dated folders
- **Rationale**: Historical tracking and cleanup of active workspace
- **Implementation**: Automated process with log entries

### Learning Loops (2024-03-15)
- **Pattern**: Extract patterns from completed work, update vault files
- **Rationale**: Continuous improvement and institutional knowledge capture
- **Implementation**: Built into Sync & Learn phase

## Learned Lessons

### Context Window Management (2024-02-20)
- **Issue**: Large rule files causing context bloat
- **Solution**: Extract detailed templates to vault files, keep rules focused
- **Impact**: Improved AI agent performance and response quality
- **Prevention**: Regular review and extraction of content to appropriate files

### Dependency Complexity (2024-03-10)
- **Issue**: Complex dependency chains causing blocking issues
- **Solution**: Enhanced dependency validation and parent-child task logic
- **Impact**: More reliable task execution and better error handling
- **Prevention**: Clear dependency documentation and validation rules
## Operations (Promoted Notes)

### Environment Defaults — Standardized (2024-01-15)
- Rationale: Normalize local expectations across agents.
- Details: env vars in `.env.local`; dev DB migrations auto-run; prefer relative paths from repo root.
- Review: 2024-07-01

### Ports & Services — Collisions (2024-01-15)
- Rationale: Reduce dev friction from port conflicts.
- Details: If `:3000` busy, use `:3001`; restart FE hot reload if stale.
- Review: 2024-07-01

### Workflow Tips — Session Hygiene (2024-01-15)
- Rationale: Avoid context drift and oversized tasks.
- Details: Always boot by reading Vault; expand tasks >2h; include FIND/REPLACE blocks; require Test Strategy; promote stable tips to patterns.
- Review: 2024-07-01

### Performance — Context Bloat (2024-01-15)
- Rationale: Keep prompts efficient.
- Details: Deduplicate to `standards.mdc`; archive regularly; use icons for quick scans.
- Review: 2024-07-01

### Troubleshooting — Quick Checks (2024-01-15)
- Rationale: Speed up common recoveries.
- Details: Check YAML ID formats for dep errors; inspect task `error_log` on failures; compare Vault timestamps for sync issues; ensure `active-context.md` updated for handoffs.
- Review: 2024-07-01
