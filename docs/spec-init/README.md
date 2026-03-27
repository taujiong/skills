# spec-init

This skill guides to bootstrap the Spec-Driven Development workflow into any project.

## Why this workflow exists

Most software projects suffer from the same silent failure mode: implementation begins before the problem is fully understood. Requirements live in someone's head, edge cases are discovered mid-sprint, and the AI agent — given incomplete context — fills in the gaps with its own assumptions. The result is drift, rework, and implementations that technically work but solve the wrong problem.

Spec-Driven Development (SDD) exists to fix this by enforcing a discipline of **making the implicit explicit before any code is written**. Every feature starts with a structured specification. That spec drives a technical plan. The plan drives an ordered task list. And only then does implementation begin — with the agent holding a complete, traceable picture of what it needs to build and why.

This traceable chain of artifacts — constitution → spec → plan → tasks — gives the AI agent sufficient context to act autonomously and dramatically reduces mid-implementation ambiguity and scope drift. When something unexpected comes up, the agent can reason against the spec rather than guessing.

`spec-init` deploys the entire SDD skill suite into your project in a single command, so you can adopt this workflow without any manual setup.

## How to get started

Run `/spec-init` once in your project. It deploys seven SDD skills into `.agents/skills/spec/` and creates the `specs/inbox/` folder where you can place external reference materials like PRDs and design specs.

## Workflow

The SDD workflow has two phases: a one-time project setup, and a repeating per-feature loop.

```text
┌─────────────────────────────────────────────┐
│               One-time setup                │
│                                             │
│  /spec-init          Bootstrap the project  │
│  /spec-constitution  Define principles      │
└─────────────────────┬───────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────┐
│              Per-spec workflow              │
│                                             │
│  /spec-specify   Draft the specification    │
│       │                                     │
│       ▼ (optional)                          │
│  /spec-clarify   Resolve ambiguities        │
│       │                                     │
│       ▼                                     │
│  /spec-plan      Produce the technical plan │
│       │                                     │
│       ▼                                     │
│  /spec-tasks     Generate the task list     │
│       │                                     │
│       ▼ (optional)                          │
│  /spec-analyze   Validate consistency       │
│       │                                     │
│       ▼                                     │
│  /spec-implement Execute and commit         │
└─────────────────────────────────────────────┘
```

The order matters. Each artifact builds on the previous one: you cannot plan what hasn't been specified, and you cannot implement what hasn't been planned. Running `spec-analyze` before `spec-implement` is optional but strongly rewards the habit — it surfaces inconsistencies while they're still cheap to fix.

## Skills in this suite

| Skill               | Description                                                                         | Doc                                          |
| ------------------- | ----------------------------------------------------------------------------------- | -------------------------------------------- |
| `spec-constitution` | Define project-wide non-negotiable principles that govern all downstream artifacts. | [spec-constitution.md](spec-constitution.md) |
| `spec-specify`      | Turn a rough feature idea into a structured, testable specification.                | [spec-specify.md](spec-specify.md)           |
| `spec-clarify`      | Refine an existing spec through targeted Q&A sessions.                              | [spec-clarify.md](spec-clarify.md)           |
| `spec-plan`         | Derive a detailed technical implementation plan from the spec.                      | [spec-plan.md](spec-plan.md)                 |
| `spec-tasks`        | Generate a TDD-ordered task checklist from the technical plan.                      | [spec-tasks.md](spec-tasks.md)               |
| `spec-analyze`      | Cross-check all artifacts for consistency, coverage, and constitution compliance.   | [spec-analyze.md](spec-analyze.md)           |
| `spec-implement`    | Execute the task checklist phase by phase, with auto-commit on each phase.          | [spec-implement.md](spec-implement.md)       |
