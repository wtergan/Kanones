---
applyTo: ".kanónes/**"  # Applies when viewing/maintaining rules & workflow assets
description: Visual workflow diagrams and process narratives showing the complete Kanónes session lifecycle from initialization through execution and synchronization
---

```mermaid
flowchart TD
    A[Initialize Session] --> B[Load Context Vault]
    B --> C{Select Mode}
    C -->|Plan| D[Plan: PRP + Tasks]
    C -->|Act| E[Act: Implement]

    D --> D1[Implementation Blueprint]
    D1 --> D2[Generate Tasks + IDs]
    D2 --> D3[Update TASKS.md]

    E --> E0{Dependency Gate}
    E0 -->|Fail| E1[Block Task]
    E0 -->|Pass| E2[Start Task]
    E2 --> E3[Add Implementation Details]
    E3 --> E4[Implement Code]
    E4 --> E5{Test Strategy Gate}
    E5 -->|Verified| E6[Validate Commands]
    E6 -->|Pass| E7[Complete Task]
    E6 -->|Fail| E8[Error Log + Iterate]

    E7 --> F[Sync & Learn]
    F --> F1[Update Vault Files]
    F1 --> F2[Extract/Update Patterns]
    F1 --> F3[Archive Completed Work]
```

## Narrative (10 lines)
- Initialize by loading the Vault: brief, active-context, patterns, progress.
- Choose mode by user intent: Plan (write/organize) or Act (implement/test).
- Plan mode produces a Thin PRP and tasks with deterministic IDs and clear validation.
- Update TASKS.md with visual status and implementation indicators.
- Act mode enforces the Dependency Gate before any work can start.
- Implement strictly via the task's Implementation Details; keep changes minimal.
- Enforce Test Strategy Gate; run or confirm exact validation commands.
- Mark complete only after cleanup and successful validation.
- Sync Vault: update progress, evolve patterns, refresh agent-notes (extended handoff + retro), and archive completed items.
- Prepare handoff: concise state & next steps in active-context; richer cross-agent context in agent-notes.

See `@standards.md` for gates, IDs, and icon mappings.
