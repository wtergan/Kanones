# Kanónes Unified Workflow (Educational Reference)

This file contains the detailed, educational version of the unified workflow that was previously in the main rules. The current streamlined version is optimized for AI agent processing and lives in `.cursor/rules/.kanónes/session-lifecycle.mdc`.

## Enhanced Phases

### 1. Initialize (Boot Session)
**Duration**: 30-60 seconds

**Mode**: Either (context loading)

**Input**:
- `.vault/memory/brief.md` - Mission and constraints
- `.vault/memory/active-context.md` - Current state and handoff notes
- `.vault/memory/patterns.md` - Conventions and decisions
- `.vault/memory/progress.md` - Recent changes and outcomes
- `.vault/memory/agent-notes.md` - Multi-agent tips and gotchas
- `.vault/tasks/TASKS.md` - Visual task overview
- `.vault/plans/PLAN.md` - Project roadmap

**Process**:
1. Read brief.md → Extract mission statement and constraints
2. Read active-context.md → Identify current focus and state
3. Read patterns.md → Load project conventions and decisions
4. Skim progress.md (last 10 entries) → Recent context and outcomes
5. Check agent-notes.md → Load multi-agent tips and gotchas
6. Review TASKS.md → Visual scan of task status indicators
7. Review PLAN.md → Project overview and active features
8. Analyze user request for Plan vs Act mode keywords

**Output**:
```markdown
## Session Ready [Mode: {Plan/Act/Ask}]
- **Project**: {name from brief.md}
- **Mission**: {one-line mission statement}
- **Current Focus**: {module/feature from active-context.md}
- **Active Tasks**: {count of [-] in_progress tasks}
- **Blocked Tasks**: {count of [/] blocked tasks}
- **Last Activity**: {date - summary from progress.md}
- **Handoff Notes**: {from active-context.md if present}
- **Agent Tips**: {relevant notes from agent-notes.md}
- **Ready**: ✓
```

**Quality Gates**:
- All vault files exist and are readable
- Session context is established
- Mode is determined or user will be asked

### 2. Orient (Establish Context)
**Duration**: 30 seconds

**Mode**: Either (planning for next action)

**Input**:
- `.vault/tasks/TASKS.md` - Task list with visual status indicators
- Relevant task files from `.vault/tasks/`
- Active PRPs from `.vault/plans/features/`
- User request analysis

**Process**:
1. **Task Selection Priority**:
   - Find highest priority task with `[ ]` status
   - Consider critical priority (🔴) over high (🟠) over medium (🟡)
   - Skip blocked tasks `[/]` unless dependencies resolved

2. **Dependency Analysis**:
   - Check `dependencies` array in task YAML
   - Verify each dependency exists and has `status: completed`
   - For dot-IDs (e.g., "42.1"), check subtask completion
   - Flag missing or incomplete dependencies

3. **Context Assessment**:
   - Review linked PRP if exists (via `links.prp`)
   - Check implementation status (detailed, code_ready, etc.)
   - Assess test strategy completeness
   - Determine if expansion needed (@expand.mdc rules)

4. **Mode Confirmation**:
   - If task selected → Act Mode for execution
   - If PRP needed → Plan Mode for planning
   - If unclear → Ask user for clarification

**Output**:
- **For Task Execution**: Selected task ID and title with dependency status
- **For Planning**: PRP creation requirement with scope
- **Mode Declaration**: Explicit Plan or Act mode
- **Next Steps**: Clear action plan

**Decision Tree**:
```markdown
Task available?
├── YES → Dependencies complete?
│   ├── YES → Implementation details exist?
│   │   ├── YES → ACT MODE: Execute task
│   │   └── NO → ACT MODE: Add implementation details
│   └── NO → ACT MODE: Block task and find alternative
└── NO → PRP needed?
    ├── YES → PLAN MODE: Create PRP
    └── NO → Ask user for direction
```

**Quality Gates**:
- Task or PRP clearly identified
- Dependencies verified (for execution)
- Implementation details available (for execution)
- Mode explicitly declared

### 3. Plan (PRP Creation/Update)
**Duration**: 5-15 minutes

**Mode**: Plan Mode ONLY

**Input**:
- User requirements and goals
- Existing code analysis and architecture
- Technical constraints and dependencies
- Business context and success metrics
- Risk assessment and mitigation strategies

**Process**:
1. **PRP Creation**:
   - Use enhanced 10-section PRP template
   - Define business and technical goals
   - Create comprehensive user stories and acceptance criteria
   - Document architecture and data flows

2. **Implementation Blueprint**:
   - Step-by-step implementation guide
   - File modification specifications
   - Database changes and migrations
   - Configuration requirements
   - Rollback procedures

3. **Validation Strategy**:
   - Test strategy for each component
   - Validation commands with expected outputs
   - Performance benchmarks and targets
   - Success criteria and metrics

4. **Risk Assessment**:
   - Identify technical and business risks
   - Define probability and impact levels
   - Create mitigation strategies
   - Document assumptions and constraints

5. **Task Generation**:
   - Break down into < 3 hour tasks
   - Set proper dependencies and priorities
   - Generate task files with full YAML metadata
   - Update TASKS.md with visual indicators

**Output**:
- **PRP Document**: Complete `.vault/plans/features/{feature}-prp.md`
- **Task Files**: Generated in `.vault/tasks/task{id}_*.md`
- **Visual Overview**: Updated `.vault/tasks/TASKS.md` with status indicators
- **Project Index**: Updated `.vault/plans/PLAN.md`

**Quality Gates**:
- ✅ Goals are measurable and time-bound
- ✅ Implementation steps are concrete and testable
- ✅ Validation criteria are executable with commands
- ✅ Tasks are < 3 hours each with clear scope
- ✅ Dependencies are properly mapped
- ✅ Risk mitigation strategies documented

### 4. Execute (Implementation)
**Duration**: Variable (per task estimate)

**Mode**: Act Mode ONLY

**Input**:
- Selected task file with full YAML metadata
- Implementation details section (copy-paste ready)
- PRP blueprint reference for context
- Test strategy section (if applicable)

**Process**:

1. **Dependency Validation** (Critical Gate):
   ```markdown
   # Must-Fail Check - DO NOT PROCEED if any dependency incomplete
   For each dep_id in task.dependencies:
     - Verify task file exists (active or archived)
     - Check status == "completed"
     - For dot-IDs (e.g., "42.1"): verify subtask completion
     - If ANY dependency incomplete: BLOCK TASK and inform user
   ```

2. **Task Activation**:
   - Update `status: in_progress`
   - Set `started_at: {UTC timestamp}`
   - Update TASKS.md: `[ ]` → `[-]`
   - Announce: "Starting task {id}: {title}"

3. **Implementation Phase**:
   - Follow implementation details exactly (copy-paste ready)
   - Update `implementation_status` progressively:
     - `detailed` → `code_ready` → `partially_implemented` → `fully_implemented`
   - Set `implementation_detailed_at` when details are added
   - Update TASKS.md implementation icons accordingly
   - Run validation commands after each file change

4. **Test Strategy Enforcement**:
   - Check for `## Test Strategy` section
   - If exists: Ask user "Run tests now or mark complete based on verification?"
   - Execute all test commands if user chooses to run
   - Update `test_strategy_verified: true/false`
   - If no test strategy: Get explicit user confirmation

5. **Code Quality**:
   - Remove debug statements and temporary code
   - Follow patterns from `patterns.md`
   - Commit changes with format: `Task {ID}: {Summary} [kanónes]`

**Output**:
- **Code Changes**: Implemented per blueprint specifications
- **Task Status**: Updated YAML with completion details
- **Timestamps**: `completed_at` or `error_log` with timestamps
- **Test Results**: Execution outcomes and verification status
- **Visual Updates**: TASKS.md reflects current status

**Guardrails** (Mandatory):
- ❌ Never implement without implementation details
- ❌ Never start task with incomplete dependencies
- ❌ Always validate after changes
- ❌ Always enforce test strategy verification
- ❌ Stop immediately if validation fails
- ❌ Clean up debug code before completion

**Error Handling**:
- **Validation Failure**: Update error_log, keep status in_progress, ask for guidance
- **Missing Dependencies**: Block task, inform user of blockers
- **Test Failures**: Document issues, keep task open for fixes

### 5. Test Verification (Mandatory Phase)
**Duration**: 5-10 minutes

**Mode**: Act Mode

**Input**:
- Task file with test strategy section
- Implemented code changes
- PRP validation requirements

**Process**:

1. **Strategy Assessment**:
   - Check for `## Test Strategy` section in task file
   - Review test commands and expected outputs
   - Assess test coverage (unit, integration, e2e)

2. **User Decision Point**:
   - If test strategy exists: Ask user:
     ```
     "This task includes test strategy. Should I:
     1. Run the tests now
     2. Mark complete based on your verification
     3. Keep task open for testing"
     ```

3. **Test Execution** (Option 1):
   - Execute all commands from Test Strategy section
   - Capture stdout/stderr and exit codes
   - Compare results against expected outputs
   - Document any failures or deviations

4. **Manual Verification** (Option 2):
   - Get explicit user confirmation
   - Document verification method in task notes
   - Log who performed verification and when

5. **Status Update**:
   - Update `test_strategy_verified: true` (if passed or confirmed)
   - Update `test_strategy_verified: false` (if failed)
   - Add test results to task notes

**Output**:
- **Test Results**: Execution outcomes or verification confirmation
- **Verification Flag**: Updated `test_strategy_verified` boolean
- **Task Status**: Ready for validation or needs fixes
- **Documentation**: Test outcomes logged in task file

**Quality Gates**:
- ✅ Test strategy exists and is appropriate
- ✅ Tests executed or manual verification obtained
- ✅ Results documented and verified
- ✅ Status flags accurately reflect outcomes

### 6. Validate (Quality Check)
**Duration**: 2-5 minutes

**Mode**: Act Mode

**Input**:
- Test verification results
- PRP acceptance criteria and success metrics
- Performance benchmarks and targets
- Implementation details completion

**Process**:

1. **Acceptance Criteria Check**:
   - Run all validation commands from PRP/Test Strategy
   - Compare results against expected outputs
   - Verify all acceptance criteria are met
   - Document any deviations or issues

2. **Performance Validation**:
   - Check performance benchmarks if specified
   - Verify response times and resource usage
   - Compare against targets in PRP
   - Flag any performance regressions

3. **Code Quality Review**:
   - Verify implementation matches blueprint
   - Check for debug code removal
   - Ensure patterns.md conventions followed
   - Validate commit message format

4. **Final Assessment**:
   - All validation commands passed
   - Acceptance criteria satisfied
   - Performance targets met
   - Code quality standards maintained

**Output**:
- **Pass/Fail Determination**: Clear completion status
- **Evidence Collection**: Metrics, test results, validation outputs
- **Issue Documentation**: Any problems identified with remediation steps
- **Completion Certificate**: All gates passed

**Quality Gates**:
- ✅ All validation commands executed successfully
- ✅ Acceptance criteria verified and met
- ✅ Performance targets achieved (if applicable)
- ✅ Code quality standards maintained
- ✅ No blocking issues remaining

### 7. Sync & Learn
**Duration**: 2-5 minutes

**Mode**: Either (context synchronization)

**Input**:
- Validation results and completion status
- Implementation decisions and technical choices
- Issues encountered and lessons learned
- New patterns or conventions discovered

**Process**:

1. **Task Status Finalization**:
   - **If Completed**: Update `status: completed`, set `completed_at` timestamp
   - **If Failed**: Update `status: failed`, add detailed `error_log`
   - Update TASKS.md: `[x]` for completed, `[!]` for failed
   - Set `actual_effort` if time tracking used

2. **Progress Documentation**:
   - Append to `progress.md` with format:
     ```
     ## YYYY-MM-DD
     - **Task {id}**: ✅ {status}, {brief summary}
       - Key outcomes: {metrics, achievements}
       - Technical notes: {important decisions}
       - Next steps: {follow-up actions}
     ```

3. **Pattern Extraction**:
   - Identify reusable solutions or new conventions
   - Add to `patterns.md` with date and context:
     ```
     ### {Pattern Name} (YYYY-MM-DD)
     - **Context**: Task {id} - {description}
     - **Pattern**: {reusable solution}
     - **Example**: {specific implementation}
     - **Rationale**: {why this approach works}
     ```

4. **Context Updates**:
   - Update `active-context.md` with new risks or changes
   - Document environmental changes or dependencies
   - Update handoff notes for multi-agent continuity

5. **Archive Consideration**:
   - Check if completed task should be archived
   - Move to `.vault/tasks/archives/` if > 24h old
   - Update `TASKS_LOG.md` with archival entry

**Output**:
- **Updated Vault Files**: All context files synchronized
- **Task Status**: Finalized with proper timestamps and documentation
- **New Patterns**: Documented for future reuse
- **Progress Log**: Complete record of work completed
- **Archive Status**: Completed work properly stored

**Quality Gates**:
- ✅ All vault files updated with current state
- ✅ Task status accurately reflects completion state
- ✅ Patterns documented for team learning
- ✅ Progress properly logged with outcomes

### 8. Wrap (Session Close)
**Duration**: 1-2 minutes

**Mode**: Either (session management)

**Input**:
- Current session state and accomplishments
- Completed work and outcomes
- Remaining tasks and priorities
- Any blockers or concerns identified

**Process**:

1. **Session Summary**:
   - List all completed tasks with IDs and brief summaries
   - Note any tasks still in progress
   - Document blocked tasks with reasons
   - Highlight key achievements or milestones

2. **Next Priority Identification**:
   - Scan TASKS.md for highest priority pending tasks
   - Consider critical path and dependencies
   - Suggest 1-2 immediate next tasks
   - Flag any urgent blockers

3. **Multi-Agent Handoff** (if needed):
   - Update `active-context.md` with handoff notes
   - Document current state and next steps
   - Add agent-specific notes to `agent-notes.md`
   - Include environmental context or special instructions

4. **Archive Check**:
   - Identify completed tasks > 24h old
   - Move eligible tasks to archives
   - Update TASKS_LOG.md with archival entries
   - Clean up TASKS.md

**Output**:
```markdown
## Session Summary [Mode: {Plan/Act}]
- **Completed**: Task {ids} - {summaries}
  - Key outcomes: {achievements, metrics}
- **In Progress**: Task {ids} - {current work}
- **Blocked**: Task {ids} - {blocker description}
- **Next Priority**: Task {id} - {title} ({priority})
- **Quality Gates**: {passed/failed count}
- **Vault Synced**: ✓
- **Handoff Ready**: ✓ (if multi-agent)

## Agent Notes
- {Specific observations or tips for next agent}
- {Environmental context or special considerations}
- {Known issues or gotchas}
```

**Quality Gates**:
- ✅ Session summary accurately reflects work completed
- ✅ Next priorities clearly identified
- ✅ Vault files properly updated and synchronized
- ✅ Handoff documentation complete (if multi-agent)

## Rules of Engagement

### Hard Rules (Mandatory)
1. **Never implement without PRP or implementation details** - Plan before execution
2. **Never start task with incomplete dependencies** - Dependency gating is mandatory
3. **Always enforce test strategy verification** - No exceptions for code changes
4. **Update TASKS.md immediately on status changes** - Bidirectional sync required
5. **Use real UTC timestamps from system commands** - Never hardcode timestamps
6. **Clean up debug code before completion** - Remove temporary code
7. **Follow strict Plan/Act mode separation** - No code changes in Plan mode

### Best Practices (Recommended)
1. Keep execution in vertical slices (< 3 hours per task)
2. Validate after each atomic change
3. Document decisions and patterns discovered
4. Expand complex tasks using @expand.mdc rules
5. Maintain bidirectional sync between task files and TASKS.md
6. Use multi-agent handoff features for collaboration
7. Keep vault files readable and scannable

## Failure and Recovery

### Validation Failure
```markdown
1. **Stop Immediately** - Do not continue with failed validation
2. **Capture Details** - Update task error_log with:
   - What failed and why
   - Expected vs actual results
   - Environment conditions
3. **Check Assumptions** - Review active-context.md and PRP assumptions
4. **Recovery Options**:
   a. **Fix and Retry** - Address root cause and re-execute
   b. **Reduce Scope** - Update PRP to smaller, achievable slice
   c. **Rollback** - Follow PRP rollback procedures
   d. **Create Bug Task** - Document as separate investigation
5. **Document Lesson** - Log incident in progress.md with learnings
6. **Update Status** - Keep task in_progress until resolved
```

### Dependency Block
```markdown
1. **Identify Blockers** - Check which dependencies are incomplete
2. **Update Task Status** - Set status: blocked
3. **Set blocked_by Array** - List all blocking dependency IDs
4. **Update Visual Indicator** - Change TASKS.md to [/]
5. **Document Block Reason** - Add explanation to task notes
6. **Find Alternative** - Look for other tasks with satisfied dependencies
7. **Monitor Dependencies** - Check for resolution in next session
```

### Environment Issues
```markdown
1. **Document Environment** - Add details to active-context.md
2. **Create Investigation Task** - Use spike task for timeboxed research
3. **Add Workaround** - Document temporary solution in patterns.md
4. **Update Assumptions** - Modify PRP if environmental assumptions changed
5. **Alert Team** - Document in agent-notes.md if multi-agent issue
6. **Log Resolution** - Update progress.md when fixed
```

## Mode Selection

### Plan Mode Triggers
**Keywords**: plan, design, architect, specify, document, create PRP, define, outline, structure, organize, break down, analyze, research

**Actions** (Plan Mode ONLY):
- ✅ Create/edit PRPs and PLAN.md
- ✅ Generate and expand tasks
- ✅ Update documentation and architecture
- ✅ Design solutions and blueprints
- ✅ Research and investigation
- ❌ NO code implementation
- ❌ NO test execution
- ❌ NO deployment actions

### Act Mode Triggers
**Keywords**: implement, code, execute, build, test, fix, deploy, run, start task, complete, debug, validate

**Actions** (Act Mode ONLY):
- ✅ Implement code changes per blueprint
- ✅ Run tests and validation commands
- ✅ Execute deployment and operational tasks
- ✅ Update task status and timestamps
- ✅ Debug and troubleshoot issues
- ❌ NO PRP editing
- ❌ NO architecture design
- ❌ NO scope changes

### Mode Selection Flow
```mermaid
flowchart TD
    A[User Request] --> B[Analyze Keywords & Context]

    B --> C{Plan Keywords?}
    C -->|Yes| D[Plan Mode]
    C -->|No| E{Act Keywords?}

    E -->|Yes| F[Act Mode]
    E -->|No| G{Task Selected?}

    G -->|Yes| H[Act Mode<br/>Execute Task]
    G -->|No| I[Ask User:<br/>"Should I Plan or Act?"]

    I --> D
    I --> F

    D --> J{PRP Created?}
    J -->|Yes| K{Ready to Execute?}
    K -->|Yes| L[Switch to Act Mode]
    K -->|No| M[Continue Planning]

    F --> N{Need Design/Planning?}
    N -->|Yes| O[Switch to Plan Mode]
    N -->|No| P[Continue Execution}

    style D fill:#e1f5fe,stroke:#01579b
    style F fill:#f3e5f5,stroke:#4a148c
```

### Mode Switching Guidelines
- **Plan → Act**: After PRP approval and tasks generated
- **Act → Plan**: When design issues discovered or scope needs adjustment
- **Clear Communication**: Always announce mode changes to user
- **Context Preservation**: Maintain session state across mode switches

## Workflow Optimization

### For Small Changes (< 30 min)
1. Skip full PRP, use task implementation details
2. Implement → Validate → Sync
3. Document pattern if reusable

### For Investigations
1. Create spike task with timebox
2. Document findings in task notes
3. Create follow-up tasks based on findings
4. Archive spike with lessons learned

## Quality Metrics

Track these metrics in progress.md to improve workflow effectiveness:

### Productivity Metrics
- **Task Cycle Time**: Average time from created → completed
- **First Attempt Success**: Percentage of tasks completed without rollback
- **Task Completion Rate**: Tasks completed vs total created
- **Session Efficiency**: Tasks per session

### Quality Metrics
- **Test Pass Rate**: Percentage of tests passing on first attempt
- **Rollback Frequency**: Number of rollbacks required per week
- **Pattern Discovery**: New reusable patterns identified per week
- **Expansion Accuracy**: How close estimated vs actual task effort

### Learning Metrics
- **Pattern Adoption**: How often new patterns are reused
- **Failure Recovery**: Time to recover from validation failures
- **Dependency Resolution**: Time to resolve blocked tasks
- **Multi-Agent Efficiency**: Handoff quality and continuity
