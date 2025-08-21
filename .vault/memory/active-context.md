# Active Context

## Current Focus
- Module/Phase: Kanónes ruleset • Implementation/Testing/Docs
- Sprint: Core System Refinement
- Branch/Env: main • development
- Flags: Core features enabled

## Scope
- In: Vault files, unified workflow, task mgmt, quality gates
- Out: External integrations, production deployment

## Interfaces
- IDEs (Cursor/VS Code/Windsurf), Git

## Risks
| Risk | P | I | Mitigation |
|------|---|---|------------|
| Context window bloat | H | H | Prune duplicates; centralize SoT |
| Template inconsistency | M | M | Use standards.mdc as canonical |
| Documentation drift | L | H | Regular sync of vault ↔ rules |

## Environment
- Build: N/A (markdown)
- Test: Manual validation via IDE
- Run: IDE rule activation
- Setup: Ensure `.cursor/`, `.vscode/`, `.windsurf/` exist

## Handoff
- Last Agent/When: Claude • 2024-01-15T10:30:00Z
- In Progress: Vault file upgrades; context-vault.mdc cleanup
- Next Priority: Complete vault upgrades
- Gotchas: Keep IDE variants consistent
- Decisions Pending: Final review of session-lifecycle.mdc
