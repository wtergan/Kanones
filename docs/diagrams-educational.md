# Kanónes System Diagrams

Simple, clear diagrams showing the Kanónes system architecture and workflow.

## System Overview

```mermaid
graph TB
    subgraph IDE["IDE Integration"]
        Cursor
        VSCode
        Windsurf
    end

    subgraph Rules["Core Rules"]
        root.mdc
        workflow.mdc
        standards.mdc
        context-vault.mdc
        tasks.mdc
        plans.mdc
        expand.mdc
    end

    subgraph Vault["Context Vault"]
        subgraph Memory["Memory Files"]
            brief.md
            active-context.md
            patterns.md
            progress.md
            agent-notes.md
        end

        subgraph Planning["Planning"]
            PLAN.md
            PRP_Documents
        end

        subgraph Tasks["Tasks"]
            TASKS.md
            Task_Files
        end
    end

    subgraph Process["Runtime Process"]
        subgraph Modes["Modes"]
            Plan_Mode
            Act_Mode
        end

        subgraph Gates["Quality Gates"]
            Dependency_Gate
            Test_Gate
            Validation_Gate
        end
    end

    IDE --> Rules
    Rules --> Vault
    Vault --> Process
    Process --> Vault

    style IDE fill:#e3f2fd,stroke:#1565c0
    style Rules fill:#f3e5f5,stroke:#7b1fa2
    style Vault fill:#e8f5e8,stroke:#2e7d32
    style Process fill:#fff3e0,stroke:#f57c00
```

## Context Vault Memory System

```mermaid
flowchart TD
    subgraph MemoryFiles["Memory Files"]
        brief.md
        active-context.md
        patterns.md
        progress.md
        agent-notes.md
    end

    subgraph SessionInit["Session Initialization"]
        Start --> LoadFiles
        LoadFiles --> ValidateContext
        ValidateContext --> Ready
    end

    subgraph SyncProcess["Synchronization"]
        TaskComplete --> UpdateFiles
        UpdateFiles --> ExtractPatterns
        ExtractPatterns --> HandoffPrep
        HandoffPrep --> SyncComplete
    end

    MemoryFiles --> LoadFiles
    Ready --> TaskComplete
    SyncComplete --> Start

    style MemoryFiles fill:#e8f5e8,stroke:#2e7d32
    style SessionInit fill:#e3f2fd,stroke:#1565c0
    style SyncProcess fill:#fff3e0,stroke:#f57c00
```

## Task Management System

```mermaid
flowchart TD
    subgraph Planning["Planning Mode"]
        PRP_Document --> TaskExpansion
        TaskExpansion --> CreateTaskFiles
        CreateTaskFiles --> UpdateTasksIndex
    end

    subgraph TaskFiles["Task Files"]
        YAML_Frontmatter
        Implementation_Details
    end

    subgraph Status["Status Tracking"]
        TASKS.md
        Status_Icons
        Implementation_Icons
    end

    subgraph Execution["Act Mode"]
        StartTask --> DependencyGate
        DependencyGate --> ImplementCode
        ImplementCode --> TestExecution
        TestExecution --> ValidateResults
        ValidateResults --> CompleteTask
    end

    PRP_Document --> CreateTaskFiles
    CreateTaskFiles --> TaskFiles
    TaskFiles --> TASKS.md
    TASKS.md --> Status

    StartTask --> Execution
    CompleteTask --> UpdateTasksIndex

    style Planning fill:#fff3e0,stroke:#f57c00
    style TaskFiles fill:#f3e5f5,stroke:#7b1fa2
    style Status fill:#e3f2fd,stroke:#1565c0
    style Execution fill:#e8f5e8,stroke:#2e7d32
```

## Quality Gates & Workflow

```mermaid
flowchart TD
    subgraph Gates["Quality Gates"]
        DependencyGate
        ImplementationGate
        TestGate
        ValidationGate
    end

    subgraph Workflow["Workflow Process"]
        StartTask --> DependencyGate
        DependencyGate -->|Pass| ImplementationGate
        ImplementationGate -->|Pass| ExecuteCode
        ExecuteCode --> TestGate
        TestGate -->|Pass| ValidationGate
        ValidationGate -->|Pass| CompleteTask
    end

    style Gates fill:#ff5722,stroke:#000,color:#fff
    style Workflow fill:#2196f3,stroke:#000,color:#fff
```

## Multi-Agent Handoff

```mermaid
flowchart LR
    subgraph CurrentAgent["Current Agent"]
        CompleteWork
        CommitChanges
        UpdateContext
        PrepareHandoff
    end

    subgraph Vault["Context Vault"]
        active-context.md
        agent-notes.md
        progress.md
    end

    subgraph NextAgent["Next Agent"]
        LoadContext
        ReviewHandoff
        ContinueWork
        UpdateNotes
    end

    CompleteWork --> CommitChanges --> UpdateContext --> PrepareHandoff --> active-context.md
    active-context.md --> LoadContext --> ReviewHandoff --> ContinueWork --> UpdateNotes --> agent-notes.md

    style CurrentAgent fill:#e1f5fe,stroke:#0277bd
    style Vault fill:#f3e5f5,stroke:#7b1fa2
    style NextAgent fill:#e8f5e8,stroke:#2e7d32
```

## Session Workflow Sequence

```mermaid
sequenceDiagram
    participant Agent
    participant IDE
    participant Rules
    participant Vault
    participant Code

    Agent->>IDE: Start Session
    IDE->>Rules: Load root.mdc
    Rules->>Vault: Initialize Context (30-60s)
    Vault->>Agent: Session Ready

    Agent->>Rules: Select Mode (Plan/Act)
    Rules->>Agent: Mode Activated

    Agent->>Rules: Select Task
    Rules->>Vault: Check Dependencies
    Vault->>Rules: Dependencies OK/Failed

    alt Dependencies OK
        Rules->>Agent: Start Task
        Agent->>Code: Implement Changes
        Code->>Rules: Run Tests
        Rules->>Agent: Test Results
        Agent->>Rules: Mark Complete
        Rules->>Vault: Sync Changes
    else Dependencies Failed
        Rules->>Agent: Block Task
    end

    Rules->>Vault: Update Context
    Vault->>Rules: Handoff Prepared
    Rules->>Agent: Session Complete
```