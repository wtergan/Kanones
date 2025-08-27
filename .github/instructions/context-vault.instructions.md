---
applyTo: ".kanónes/.vault/memory/**"  # Narrow: only Vault memory (brief, active-context, patterns, progress, agent-notes)
description: Memory management and synchronization for the Context Vault - handles session initialization, file loading, pattern extraction, and multi-agent handoff
---

## Activation
- See `@root.md` for activation and mode rules.

## Objective
- Maintain a compact, durable memory of project intent, active focus, conventions, and progress
- Provide stable priming across AI sessions without re-reading the entire repo
- Enable seamless handoff between different AI agents (Claude, GPT, Gemini, etc.)
- Track lessons learned and pattern evolution

## Directory Structure
- See `@standards.md → Directory Map`.

## Session Boot Checklist (Enhanced)

### Quick Start (30 seconds)
```markdown
1. Read brief.md → Understand mission (5 sec)
2. Read active-context.md → Current state (10 sec)
3. Skim patterns.md → Key conventions (10 sec)
4. Check progress.md (last 5 entries) → Recent work (5 sec)
 5. Skim agent-notes.md → Last cross-agent handoff & prefs (5 sec)
```

### Full Initialize (60 seconds)
1) brief.md — problem space  
2) active-context.md — state, env, handoff  
3) patterns.md — conventions/decisions  
4) progress.md — last 20 entries  
5) TASKS.md — status scan  
6) PLAN.md — roadmap/features  
7) agent-notes.md — per-agent prefs, extended handoff, recent retros

### Output Template
```markdown
## Session Initialized
- **Project**: {name from brief.md}
- **Mission**: {one-line mission}
- **Current Module**: {from active-context.md}
- **Active Tasks**: {count of [-] tasks}
- **Blocked Tasks**: {count of [/] tasks}
- **Last Update**: {from progress.md}
- **Key Pattern**: {most recent from patterns.md}
- **Agent**: {current AI identifier}
- **Ready**: ✓
```

## File Purposes
- brief.md — mission, constraints, stakeholders, success criteria.
- active-context.md — current focus, state snapshot, risks, handoff notes.
- patterns.md — conventions, decisions, lessons; split into `patterns/` if >80 lines.
- progress.md — dated journal of changes, outcomes, learnings.
- agent-notes.md — per-agent preferences, short retros; promote stable notes to patterns.

## Sync Rules (Enhanced)

### After Task Completion
```markdown
1. Update task file:
   - status: completed
   - completed_at: {UTC timestamp}
   - actual_effort: {time taken}

2. Update TASKS.md:
   - Change icon to [x]
   - Update implementation status icon

3. Append to progress.md:
   - Date, task ID, summary
   - Key outcomes/metrics
   - Any learnings

4. If new pattern emerged:
   - Add to patterns.md with date
   - Include example and rationale

5. If environment changed:
   - Update active-context.md
   - Note in agent-notes.md if agent-specific (include tool/agent impacted)
```

### After Session End
```markdown
1. Update active-context.md:
   - Handoff notes section
   - In-progress work
   - Next priorities

2. Extend agent-notes.md:
   - Update relevant CLI or IDE section 'Last:' timestamp (UTC)
   - Append/refresh Prefs/Strengths/Limits deltas (promote stable items to patterns)
   - Add entry to Session Retros (focus: cross-agent coordination + workflow meta, NOT duplicate of active-context handoff)

3. Quick scan for archive candidates:
   - Completed tasks older than 24h
   - Delivered PRPs
```

### Pattern Evolution
```markdown
When patterns.md > 200 lines:
1. Create patterns/ directory
2. Split into topic files:
   - patterns/code-conventions.md
   - patterns/architecture.md
   - patterns/operations.md
   - patterns/lessons.md
3. Keep patterns.md as index with links
```

## Archive Flow
- See `@standards.md → Archive Flow`.

## Quality Standards

### File Size Limits
- See `@standards.md → File Size Budgets`.

### Readability Requirements
- Each file scannable in < 30 seconds
- Use consistent markdown formatting
- Include examples for patterns
- Date all entries (YYYY-MM-DD)

### Update Frequency
- brief.md: Major pivots only
- active-context.md: Every session
- patterns.md: New discoveries
- progress.md: Every task completion
- agent-notes.md: Session end or handoff

## Multi-Agent Compatibility

### Standard Formats
- Use ISO 8601 for dates (YYYY-MM-DD)
- UTC timestamps (YYYY-MM-DDTHH:MM:SSZ)
- Relative file paths from project root
- No agent-specific syntax in vault files

### Agent Detection
- Claude: Artifact support, .mdc rules
- GPT: Code interpreter, plugins
- Gemini: Bard extensions
- Human: No AI assistance markers

### Handoff Protocol
- All changes committed and tested
- active-context.md updated with handoff notes
- Next priorities clearly identified
- Environment context documented

## Consistency Checks

### Daily Validation
- Verify required vault files exist
- Check TASKS.md synchronization
- Validate dependency integrity

### Weekly Cleanup
- Archive completed tasks and PRPs
- Rotate large log files
- Update patterns index
- Consolidate progress entries

## Integration Points

### With Task System
- Tasks reference PRPs and update progress.md on completion
- Failed tasks add lessons to patterns.md

### With Planning System
- PRPs reference patterns.md for conventions
- PLAN.md provides project overview

### With Version Control
- Use .gitignore for sensitive vault files
- Commit format: "Task {ID}: {Summary} [kanónes]"

## Emergency Recovery

### Vault Corruption
```bash
# Restore from git
git checkout HEAD -- .vault/memory/

# Rebuild from tasks and plans
find .vault -name "*.md" -type f | while read f; do
  echo "Found: $f"
done > vault-inventory.txt

# Reconstruct progress from git log
git log --oneline --grep="Task [0-9]" > task-history.txt
```

### Lost Session
```markdown
## Recovery Steps
1. Check active-context.md handoff notes
2. Review last 5 progress.md entries
3. Run test suite to verify state
4. Check git status for uncommitted changes
5. Resume from last completed task
```

## Maintenance Scripts

### vault-summary.sh
```bash
#!/bin/bash
echo "=== Vault Summary ==="
echo "Tasks: $(grep -c "^\- \[" .vault/tasks/TASKS.md)"
echo "Patterns: $(grep -c "^###" .vault/memory/patterns.md)"
echo "Progress entries: $(grep -c "^## " .vault/memory/progress.md)"
echo "Last update: $(grep "^## " .vault/memory/progress.md | head -1)"
```

### vault-health.sh
```bash
#!/bin/bash
# Check vault health
errors=0

# Check file sizes
for file in .vault/memory/*.md; do
  size=$(wc -l < "$file")
  if [ $size -gt 500 ]; then
    echo "WARNING: $file has $size lines"
    ((errors++))
  fi
done

# Check sync status
task_count=$(find .vault/tasks -name "task*.md" | wc -l)
list_count=$(grep -c "^\- \[" .vault/tasks/TASKS.md)
if [ $task_count -ne $list_count ]; then
  echo "ERROR: Task count mismatch"
  ((errors++))
fi

exit $errors
```
