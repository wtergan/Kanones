---
applyTo: ".kanónes/.github/instructions/**"  # Applies when authoring/refining instruction definition files
description: Centralized standards and conventions for Kanónes including directory structure, task IDs, status icons, quality gates, and archival policies
---

This file centralizes canonical definitions referenced by all other rules. Do not duplicate its contents elsewhere; link to sections here.

## Directory Map
```
kanónes/
├── README.md
├── cursor/rules/kanónes/               # Cursor rules (this folder)
│   ├── root.mdc
│   ├── workflow.mdc                    # Canonical workflow diagram + narrative
│   ├── standards.mdc                   # You are here
│   ├── plans.mdc
│   ├── tasks.mdc
│   ├── context-vault.mdc
│   └── expand.mdc
├── .vscode/rules/.kanónes/             # VS Code wrappers (thin, link back)
├── .windsurf/rules/.kanónes/           # Windsurf wrappers (if present)
└── .vault/                             # Context Vault (runtime)
    ├── memory/
    │   ├── brief.md
    │   ├── active-context.md
    │   ├── patterns.md
    │   ├── progress.md
    │   └── agent-notes.md
    ├── plans/
    │   ├── PLAN.md
    │   ├── features/
    │   ├── archives/
    │   └── PLANS_LOG.md
    └── tasks/
        ├── TASKS.md
        ├── archives/
        └── TASKS_LOG.md
```

## Timestamp Policy (UTC)
- Use real UTC timestamps only: `date -u +"%Y-%m-%dT%H:%M:%SZ"`.
- Apply a single batch timestamp when updating multiple related fields.

## Status, Priority, and Icons

### Task Status Icons (`.vault/tasks/TASKS.md`)
- `[ ]`: pending
- `[-]`: in_progress
- `[/]`: blocked
- `[x]`: completed
- `[!]`: failed

### Implementation Status Icons
- `📝`: detailed
- `⚡`: code_ready
- `🔧`: partially_implemented
- `✅`: fully_implemented
- `🧪`: needs_testing (derived: in_progress AND `test_strategy_verified=false`)

### Priority Indicators
- `🔴`: critical
- `🟠`: high
- `🟡`: medium
- `🟢`: low

## Deterministic IDs and Filenames

### Task IDs
1. Top-level IDs: find numeric max across `.vault/tasks/task{N}_*.md` and `.vault/tasks/archives/YYYY-MM-DD__task{N}__*.md`; new ID = max+1 (start at 1).
2. Subtask IDs: `{parent}.{sub}` (e.g., `42.1`); find max sub per parent across active + archives; YAML `id` must be full string (`"42.1"`).

### Filenames
- Top-level: `task{id}_{slug}.md` (e.g., `task42_auth_system.md`).
- Subtask: `task{parent}.{sub}_{slug}.md` (e.g., `task42.1_create_jwt_service.md`).
- Archived: `YYYY-MM-DD__task{id}__{slug}.md`.

## Archive Flow (Tasks and PRPs)

### Triggers
- Status is `completed` or `failed` (tasks) or PRP delivered/closed.
- Optional holding period: 24h.

### Process
1. Move file to the appropriate `archives/` folder with dated filename.
2. Append summary entry to `TASKS_LOG.md` or `PLANS_LOG.md` (append-only).
3. Update indexes (`TASKS.md`, `PLAN.md`) to remove or mark archived items.

## Quality Gates (Canonical)

### Dependency Gate (Must-Fail)
- A task may not start unless all IDs listed in `dependencies` exist and have `status: completed` in either active or archived tasks.
- If any dependency is missing or incomplete, set `status: blocked`, record in `blocked_by`, and output a blocking message.

### Test Strategy Gate (Mandatory)
- Code tasks must include a "## Test Strategy" section before completion.
- Verification path:
  - Prefer executing exact commands provided;
  - If execution is not possible, require explicit user confirmation before toggling `test_strategy_verified: true`.

### Validation Commands Contract
- Provide exact commands and expected outputs under "## Validation Commands".
- Completion requires that all validation commands pass or are verified.

### Cleanup-Before-Complete
- Remove debug prints, temporary comments, and unused code before setting `status: completed`.

## Expansion Policy (Canonical)

### When to Expand a Task
- Estimated effort > 2–3 hours, or validation takes > 10 minutes.
- Cross-cutting changes across multiple components/services.
- Unclear interfaces or data contracts; unknowns/risks high.
- > 5 distinct acceptance/validation points.

### Subtask IDs and Files
- IDs use dot-notation per parent, e.g., `42.1`, `42.2` (YAML `id: "42.1"`).
- Filenames: `task{parent}.{sub}_{slug}.md`.

### Concurrency Rules
- Allow parallel subtasks only if interfaces are stable, tests independent, and no shared state writes.
- Default to serialized order; make dependencies explicit.

### Exit Criteria per Subtask
- Builds/compiles cleanly; tests/checks pass; acceptance met.
- Implementation Details documented; Vault sync completed.

### Parent/Child Rules
- Creating subtasks sets parent `status: blocked`.
- Parent completes only when all children are `completed`.

References: detailed heuristics in `@expand.md`. Task wiring in `@tasks.md`.

## File Size Budgets (for Vault)
- `brief.md` ≤ 100 lines
- `active-context.md` ≤ 120 lines
- `agent-notes.md` ≤ 120 lines (keep last 5 retros max)
- `patterns.md` ≤ 80 lines as index; split into `patterns/*.md` when growing
- `progress.md` ≤ 500 lines; yearly archive to `archives/`

## References
- Workflow diagram and lifecycle: see `@workflow.md`.
- Task lifecycle details: see `@tasks.md`.
- Plan templates and guidance: see `@plans.md`.
- PRP template with AI agent optimization: see `@plans.md → PRP Template (Feature)`.
- Task generation from PRPs: see `@tasks.md → Creation Flow` and `@expand.md → Expansion Patterns`.
