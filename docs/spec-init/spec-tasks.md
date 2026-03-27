# spec-tasks

This skill guides to generate a TDD-ordered, dependency-aware task checklist from a technical plan.

## When to use it

A technical plan describes the architecture and the files involved, but it doesn't tell the agent _in what order_ to do the work. Implementation order matters — building a feature before its data model exists, or writing implementation before tests, leads to fragile code and wasted effort.

`spec-tasks` converts the technical plan into an actionable task checklist that respects both dependency order and TDD principles. Tests always come before their corresponding implementation. The four-phase structure (Setup → Foundational → Per-User-Story → Cross-Cutting Concerns) ensures infrastructure is in place before feature work begins.

The resulting `tasks.md` is what `/spec-implement` works from. Generate it after `plan.md` is stable and before starting implementation. If the plan is later revised, you can re-run this skill in merge mode to incorporate new tasks without discarding already-completed work.

## How to use it

Trigger the skill with `/spec-tasks` followed by the spec name.

**Example — generating tasks for a new plan:**

```
/spec-tasks notification-system
```

The agent reads `spec.md` and `plan.md` and produces `specs/notification-system/tasks.md`.

**Example — updating tasks after a plan revision:**

```
/spec-tasks notification-system
> The plan was updated to add push notifications via a new service
```

The skill merges new tasks into the existing checklist, preserving checkmarks on already-completed tasks.

## Reference

### Syntax

```
/spec-tasks <spec-name>
```

| Argument      | Required | Description                                                                   |
| ------------- | -------- | ----------------------------------------------------------------------------- |
| `<spec-name>` | Yes      | Name of the spec to generate tasks for (matches the directory under `specs/`) |

### Output

Creates `specs/<spec-name>/tasks.md`. Tasks are organized into four phases:

1. **Setup** — environment, tooling, and scaffolding tasks
2. **Foundational** — data models, schemas, shared utilities
3. **Per-User-Story** — one group of tasks per user story from the spec
4. **Cross-Cutting Concerns** — error handling, logging, documentation, performance

Within each phase, test stubs and test cases appear before their corresponding implementation tasks.

### Behavior notes

- Requires both `spec.md` and `plan.md` to be present and free of unresolved markers (`TODO`, `TBD`, `NEEDS CLARIFICATION`) before proceeding. If unresolved markers are found, the skill reports them and stops.
- Tasks follow TDD order within each phase: test stubs first, then implementation.
- When `tasks.md` already exists, the skill runs in merge mode: new tasks are inserted in the correct phase position, and previously completed tasks (checked off) are preserved.
- Each task includes a reference to the user story or plan decision it derives from, creating traceability back to the spec.
