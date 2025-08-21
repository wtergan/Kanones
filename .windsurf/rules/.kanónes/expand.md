---
trigger: always_on
description: Task decomposition and expansion logic for breaking down complex work into executable 2-hour tasks with proper dependency mapping
---

## Activation
- See `@root.md` for activation and mode rules.

## Mode
- Plan Mode only (analysis/decomposition). Output: recommended subtask structure with dependencies.
Note: Canonical expansion policy lives in `@standards.md`.

## Principles
- Short feedback loops; each slice validates independently.
- Prefer vertical depth; finish a thin end-to-end path.
- Postpone polish until correctness gates pass.
- Subtasks should be 1–2 hours.

## Expansion Criteria (any)
- Effort > 2–3 hours; validation > 10 minutes; >2 unresolved deps/unknowns.
- Multi-component, cross-boundary, or involves DB migrations + logic.
- Ambiguous interfaces; >5 validation points.

### Decision Heuristic (scored)
Expand if score ≥ 4 (≥3 if timeline tight):
- Time > 3h → 2
- Spans multiple modules/services → 2
- >2 unresolved deps/unknowns → 2
- Ambiguous API/data contract → 1
- Acceptance criteria >5 items → 1
- External integration + internal change → 1

## Expansion Patterns (examples)
- Feature: scaffold → core → tests → edges → polish
- Refactor: isolate → parallel → verify → cutover → cleanup
- Migration: dual-write → dual-read → verify → cutover → cleanup
- Spike: research → prototype → evaluate → document

## Subtask Naming
- See @standards.md → Deterministic IDs and Filenames

## Expansion Output (minimal)
- Rationale: why expand, total effort, key risks.
- Proposed subtasks: ID, title, 1–2 line description, deps, effort, validation.
- Optional: tiny dependency graph (mermaid) if helpful.

## Concurrency
- Default serialize; only parallelize when interfaces are stable and tests are independent.

## Exit Criteria
- Build passes; tests/acceptance pass; Impl. Details documented; Vault synced.

## Anti-Patterns to Avoid
- ❌ Creating subtasks for trivial operations (< 30 min work)
- ❌ Over-decomposing into micro-tasks
- ❌ Mixing investigation with implementation
- ❌ Creating subtasks without clear validation criteria
- ❌ Parallel tasks with hidden dependencies

## Operational Ties
- After approval: list subtasks in parent, generate subtask files, update `TASKS.md`, set parent `blocked`.
- Unknowns: add a spike with timebox ≤4h and explicit exit criteria.

## Expansion Triggers
User commands that trigger expansion analysis:
- "expand task {id}"
- "break down task {id}"
- "this task seems too large"
- "analyze task {id} complexity"

## Quality Checks Before Expansion
1. Can this be simplified instead of expanded?
2. Are the interfaces well-defined?
3. Will subtasks provide value independently?
4. Is the validation strategy clear for each slice?
5. Does expansion reduce overall project risk?

## Example Expansion

```markdown
Original Task 15: Implement User Authentication

After analysis, expanding into:
- 15.1: Create auth database schema (1 hr)
- 15.2: Implement JWT token service (2 hrs)  
- 15.3: Add login/logout endpoints (2 hrs)
- 15.4: Create middleware for route protection (1 hr)
- 15.5: Add user session management (1 hr)
- 15.6: Write integration tests (1 hr)

Total: 8 hrs (original estimate: 6-8 hrs)
Each subtask independently testable.
```
