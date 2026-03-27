# spec-specify

This skill guides to turn a rough feature idea into a formal, testable specification.

## When to use it

A feature description in plain language is rarely complete enough to build from. It captures intent but leaves out edge cases, data constraints, failure modes, and non-functional requirements. When an AI agent fills those gaps on its own, the result often surprises the person who asked for the feature.

`spec-specify` solves this by transforming a free-form description into a structured `spec.md` file. The output is precise enough that downstream skills — plan, tasks, and implement — can work from it without needing to guess at requirements. It also reads any reference materials you've placed in `specs/inbox/` (PRDs, design specs, API contracts), so you don't have to repeat context the agent could read directly.

Reach for this skill at the start of any new feature, bug fix, or refactor that's complex enough to warrant documentation. If the scope is trivial, you don't need it. If you're unsure, it's usually faster to write the spec than to undo a wrong implementation.

## How to use it

Trigger the skill with `/spec-specify` followed by a description of what you want to build.

**Example — new feature from scratch:**

```
/spec-specify Add a user notification system that sends email and in-app alerts
```

**Example — using inbox reference materials:**

Place a PRD file at `specs/inbox/notifications.prd.md` first, then:

```
/spec-specify notification system
```

The agent will read the PRD automatically before generating the spec.

**Example — when you want to answer questions upfront:**

```
/spec-specify password reset flow — users should get a time-limited link via email, valid for 15 minutes
```

The more context you provide in the trigger, the fewer clarifying questions the agent needs to ask.

## Reference

### Syntax

```
/spec-specify <description>
```

| Argument        | Required | Description                                               |
| --------------- | -------- | --------------------------------------------------------- |
| `<description>` | Yes      | Free-form description of the feature or change to specify |

### Output

Creates `specs/<name>/spec.md`. The file includes:

- User stories in Given/When/Then format
- Edge case definitions
- Functional and non-functional requirements
- Explicitly testable success criteria

The spec becomes the single source of truth for all downstream artifacts (`plan.md`, `tasks.md`, implementation).

### Behavior notes

- Before generating the spec, the skill reads all files present in `specs/inbox/` that follow the naming conventions (`*.prd.md`, `*.design.md`, `*.contract.md`).
- The skill asks at most **3 scope-critical clarifying questions** to resolve ambiguity. It will not proceed with open questions that would materially affect the spec's shape.
- The `<name>` used for the spec directory is derived from the feature description. The agent may ask for confirmation if the name is ambiguous.
