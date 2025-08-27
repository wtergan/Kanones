---
applyTo: ".kanónes/.vault/memory/**"  # Focus lifecycle guidance where handoff/state snapshot maintained
description: Quick-reference checklist and unified workflow guide combining references to all Kanónes components and processes
---

- Activation and mode rules: see `@root.md`.
- Canonical diagram and lifecycle: see `@workflow.md`.
- Gates, IDs, icons, archive: see `@standards.md`.

## Operator Checklist
- Initialize: load Vault (brief, active-context, patterns, progress, agent-notes).
- Decide mode: Plan (author/update PRD/PRP and tasks) or Act (implement).
- Plan: write Thin PRP; generate tasks with IDs; update `TASKS.md`.
- Act: enforce dependency gate; implement per Implementation Details.
- Test: verify Test Strategy; run or confirm validation commands.
- Validate: ensure acceptance criteria; update flags and statuses.
- Sync & Learn: update progress, extract patterns, update agent-notes (extended handoff + retro), consider archive.
- Handoff: update active-context (concise next steps) distinct from extended notes in agent-notes.
