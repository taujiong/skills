# spec-init

This skill bootstraps the **Spec-Driven Development (SDD)** workflow into any project. Run it once and it deploys 7 SDD-related skills into `.agents/skills/spec/` and creates the `specs/inbox/` folder for external reference documents.

## Usage

```prompt
/spec-init
```

Once bootstrapped, the following skills become available in the target project:

| Skill               | Description                                   |
| ------------------- | --------------------------------------------- |
| `spec-constitution` | Define project-wide non-negotiable principles |
| `spec-specify`      | Turn a rough idea into a structured spec      |
| `spec-clarify`      | Refine an existing spec with targeted Q&A     |
| `spec-plan`         | Derive a technical plan from the spec         |
| `spec-tasks`        | Generate a TDD-ordered task checklist         |
| `spec-analyze`      | Cross-check all artifacts for consistency     |
| `spec-implement`    | Execute tasks phase by phase with auto-commit |

## Spec-Driven Development

The SDD workflow enforces a discipline of **making the implicit explicit** before any code is written.

By producing a traceable chain of artifacts — constitution → spec → plan → tasks — every implementation decision is grounded in a documented requirement. This gives the AI agent sufficient context to act autonomously and reduces mid-implementation ambiguity and scope drift.

## Typical Workflow

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

## `specs/inbox`

Before authoring a specification, place external reference materials into `specs/inbox/`. Downstream skills automatically discover and incorporate these files based on their naming convention.

The built-in resource types are:

| File type             | Convention      |
| --------------------- | --------------- |
| Product Requirements  | `*.prd.md`      |
| Design specifications | `*.design.md`   |
| API contracts         | `*.contract.md` |

The convention is extensible — additional resource types can be defined by following the same `*.<type>.md` pattern. This provides a structured handoff point for any external input, such as product briefs, design mockups, or third-party API documentation.

## Skills

**`spec-constitution`**

Establishes `specs/constitution.md` — the project's authoritative set of non-negotiable principles, expressed in RFC 2119 language (`MUST`, `SHOULD`, `MAY`).

- Serves as the governance layer for the entire SDD workflow
- Constitutional rules are automatically injected as compliance checks into every spec, plan, and task list produced afterward
- Performs impact analysis when rules are tightened, identifying existing code that may violate updated constraints
- Should be run before any feature work to ensure all downstream artifacts are generated within the correct constraints

---

**`spec-specify`**

Transforms a free-form feature description into a formal specification file at `specs/<name>/spec.md`.

- Reads any documents present in `specs/inbox/` before generating the spec
- Asks at most **3 scope-critical clarifying questions** to resolve ambiguity early
- Output includes user stories in Given/When/Then format, edge case definitions, functional and non-functional requirements, and explicitly testable success criteria
- The resulting spec is the single source of truth for all downstream artifacts

---

**`spec-clarify`**

Performs iterative refinement of an existing `spec.md` through a structured Q&A process.

- Scans the specification across **9 taxonomy categories**: scope boundaries, data model, UX behaviour, non-functional requirements, integrations, edge cases, terminology, completion signals, and unresolved placeholders
- Surfaces up to **5 targeted, answerable questions** per session
- Records each session's Q&A under a versioned `### Session N` heading directly within the spec file, creating a permanent audit trail
- Use whenever a spec contains ambiguous language, open questions, or `TBD` markers before moving to planning

---

**`spec-plan`**

Derives a technical plan at `specs/<name>/plan.md` from the approved specification.

- Inspects the existing project structure to determine whether the work is greenfield or an addition to an existing codebase
- Produces architecture decisions with explicit rationale, a complete annotated file modification tree, and dependency and data model changes
- Includes a constitution compliance gate that verifies all `MUST`/`SHOULD` constraints are satisfied before implementation begins
- Supports an update mode that merges revisions into an existing plan without discarding prior decisions

---

**`spec-tasks`**

Converts the technical plan into a fully actionable, dependency-ordered task checklist at `specs/<name>/tasks.md`.

- Requires both `spec.md` and `plan.md` to be present and free of unresolved markers (`TODO`, `TBD`, `NEEDS CLARIFICATION`) before proceeding
- Tasks are structured into four phases: **Setup → Foundational → Per-User-Story → Cross-Cutting Concerns**
- Ordered following TDD principles: test stubs and test cases are always listed before their corresponding implementation tasks
- Supports both create and incremental update (merge) modes, preserving already-completed work when a plan is revised

---

**`spec-analyze`**

A read-only consistency analyzer that audits all four artifacts — `spec.md`, `plan.md`, `tasks.md`, and `constitution.md` — against each other.

- Detects duplication, ambiguity, underspecification, and constitution violations
- Identifies requirement coverage gaps (requirements with no corresponding tasks) and terminology drift between documents
- Results are presented as a severity-ranked findings table (CRITICAL / HIGH / MEDIUM / LOW), capped at 50 rows
- Recommended remediation commands are included alongside each finding
- Run this before `spec-implement` to surface issues early

---

**`spec-implement`**

Executes the task checklist in `tasks.md` phase by phase, driving the AI agent through the full implementation.

- Supports `--story` and `--phase` flags to scope execution to a subset of work
- Automatically resumes from the first incomplete task when re-invoked
- TDD-aware: expects tests to fail (RED) before writing implementation code (GREEN)
- Applies up to **3 self-correction attempts** on errors before escalating to the user
- Creates a git commit in **Conventional Commits** format upon completing each phase
