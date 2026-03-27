# spec-plan

This skill guides to derive a detailed technical implementation plan from a specification.

## When to use it

A specification describes _what_ to build; it deliberately avoids prescribing _how_. That gap is where implementation decisions live — which files to modify, which architectural patterns to use, how the data model changes, what dependencies are introduced. Without a written plan, those decisions happen implicitly during coding and are rarely revisited or documented.

`spec-plan` bridges this gap. It reads your approved `spec.md`, inspects the existing project structure, and produces a `plan.md` that captures architecture decisions with explicit rationale, a complete annotated list of files to create or modify, and dependency and data model changes. It also runs a constitution compliance gate before finalizing, verifying that every `MUST` and `SHOULD` constraint is satisfied.

Use this skill after `/spec-specify` (and optionally `/spec-clarify`) has produced a stable spec. If the spec still has `TBD` markers or open questions, resolve them with `/spec-clarify` first — an ambiguous spec produces an ambiguous plan.

## How to use it

Trigger the skill with `/spec-plan` followed by the spec name.

**Example — generating a plan for a new feature:**

```
/spec-plan notification-system
```

The agent inspects your codebase, reads the spec, and produces `specs/notification-system/plan.md`.

**Example — updating a plan after the spec changed:**

```
/spec-plan notification-system
> The spec was updated to add push notification support
```

When a plan already exists, the skill enters update mode: it merges revisions into the existing plan without discarding prior architecture decisions.

## Reference

### Syntax

```
/spec-plan <spec-name>
```

| Argument      | Required | Description                                                     |
| ------------- | -------- | --------------------------------------------------------------- |
| `<spec-name>` | Yes      | Name of the spec to plan (matches the directory under `specs/`) |

### Output

Creates `specs/<spec-name>/plan.md`. The file includes:

- Architecture decisions with explicit rationale
- A complete annotated file modification tree (files to create, modify, or delete)
- Dependency changes
- Data model changes
- A constitution compliance gate summary

### Behavior notes

- The skill inspects the existing project structure to determine whether the work is greenfield or an addition to an existing codebase, and adjusts its output accordingly.
- If `specs/constitution.md` exists, a compliance gate is run before the plan is finalized. Any `MUST`/`SHOULD` violations are reported and must be resolved.
- When a `plan.md` already exists, the skill runs in update mode: it merges new decisions into the existing file rather than replacing it, preserving prior decisions that remain valid.
- The skill requires `spec.md` to be present and free of unresolved markers (`TBD`, `NEEDS CLARIFICATION`) before proceeding.
