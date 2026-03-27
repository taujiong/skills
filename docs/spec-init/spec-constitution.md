# spec-constitution

This skill guides to define project-wide non-negotiable development principles.

## When to use it

Every project carries implicit standards — "we always write tests", "never expose raw errors to the client", "all public APIs must be documented". These rules usually live in someone's head or scattered across wiki pages, and an AI agent working autonomously has no way to know about them unless they're written down.

`spec-constitution` solves this by creating `specs/constitution.md`: a single, authoritative document of your project's non-negotiable constraints, written in RFC 2119 language (`MUST`, `SHOULD`, `MAY`). Once established, every spec, plan, and task list the agent produces will be automatically checked against these rules.

Run this skill once at project setup, before any feature work begins. That way, all downstream artifacts are generated within the correct constraints from the start. You can return to it later to tighten rules or add new ones — the skill will perform an impact analysis to identify existing artifacts that may need to be updated.

## How to use it

Trigger the skill with `/spec-constitution`. The agent will guide you through articulating your project's principles and produce `specs/constitution.md`.

**Example — initial setup:**

```
/spec-constitution
```

The agent will ask clarifying questions to capture your standards across areas like testing, error handling, API design, security, and code style, then produce the constitution file.

**Example — updating existing rules:**

```
/spec-constitution
> I want to add a rule that all database queries must go through the repository layer
```

When updating, the agent performs an impact analysis: it identifies any existing specs, plans, or task lists that may conflict with the new or tightened rule.

## Reference

### Syntax

```
/spec-constitution
```

No arguments required. The skill infers the project root from context.

### Output

Creates or updates `specs/constitution.md`. The file uses RFC 2119 language (`MUST`, `SHOULD`, `MAY`) to express each principle unambiguously.

### Behavior notes

- If `specs/constitution.md` already exists, the skill enters update mode rather than overwriting.
- On update, the skill performs an impact analysis against existing `spec.md`, `plan.md`, and `tasks.md` files to surface potential violations of newly added or tightened rules.
- Constitutional rules are injected as compliance checks into every artifact produced by the other skills in the suite.
