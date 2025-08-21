---
trigger: always_on
description: Entry point and system initialization for the Kanónes agentic ruleset - handles session startup, mode selection, and core workflow coordination
---

## Activation
- Begin responses with: "Activating kanónes root…"
- When unsure of mode: ask whether to Plan or Act
- Append mode indicator: "[Plan Mode]" or "[Act Mode]"

## Purpose
- Context-first operations with a persistent Context Vault
- Deterministic workflow: Initialize → Plan (PRP) → Execute → Validate → Sync & Learn
- Single source of truth for plans and tasks; clean archival
- Maintain project continuity across different AI agents and sessions

## Mode Gating (hard)
- **Plan Mode**: analysis, author/edit docs (PRPs, tasks metadata). 
  - **Forbidden**: editing source code, running installers, starting services, making network calls
  - **Allowed**: Creating/updating documentation, task planning, architecture design
- **Act Mode**: implement code strictly per approved PRP/task Implementation Details. Always validate before sync.
  - **Required**: Test execution before marking complete
  - **Cleanup**: Remove debug statements before completion

## Timestamp Policy (UTC)
- See `@standards.md → Timestamp Policy` (canonical).

## Session Initialization Checklist
1. **Load Context Vault** (5-10 seconds per file)
   - Read `.vault/memory/brief.md` → understand problem space
   - Read `.vault/memory/active-context.md` → current state
   - Read `.vault/memory/patterns.md` → conventions
   - Skim `.vault/memory/progress.md` → recent changes
2. **Check Active Work**
   - Review `.vault/tasks/TASKS.md` for pending tasks
   - Check `.vault/plans/PLAN.md` for project overview
3. **Announce Ready State**
   - Summarize understanding and intended scope
   - Confirm mode (Plan/Act) with user if unclear

## What this gives you
- Faster ramp for agents through stable memory and conventions
- Reduced looping via small vertical slices and explicit validation gates
- Traceability: every change ties back to a PRP and task ID
- Cross-agent compatibility through standardized context format

## Key Entry Points
- `@context-vault.md` – context model, files, sync rules
- `@workflow.md` – canonical lifecycle diagram + narrative
- `@standards.md` – directory, IDs, icons, gates, archive, timestamps
- `@plans.md` – PRP authoring + PLAN.md guidance
- `@tasks.md` – tasks layout and operations (Implementation Details spec)
- `@expand.md` – how to split work into executable slices (Plan Mode only)

## Directory Map
- See `@standards.md → Directory Map` (canonical; do not duplicate here).

## Operating Guarantees
- Plan before Act; PRP governs scope and validation.
- Maintain bidirectional sync between `.vault/tasks/TASKS.md` and task files.
- Validate first; then sync Vault (progress, patterns) and archive.
- See `@standards.md → Quality Gates` and `→ Archive Flow` for canonical rules.

## Quality Standards
- Each task must be completable in < 2 hours
- All code changes must have validation criteria
- Context files must be readable in < 30 seconds
- Implementation details must be copy-paste ready
- Test strategies are mandatory for code changes

## How to Use
1. Start with `@session-lifecycle.md initialize session`
2. For any non-trivial change: `@plans.md create PRP for <feature>`
3. Generate tasks from a PRP: `@tasks.md create tasks for <PRP>`
4. Expand complex tasks: `@expand.md analyze task <id>`
5. Keep vault updated: `@context-vault.md sync`

## Cross-Agent Compatibility Notes
- Context Vault designed for portability across Claude, GPT, Gemini, etc.
- Use standard Markdown without agent-specific extensions
- Keep file references relative to project root
- Document environment assumptions in active-context.md
