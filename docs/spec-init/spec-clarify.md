# spec-clarify

This skill guides to iteratively refine an existing spec by surfacing and resolving ambiguities.

## When to use it

A first-draft spec is rarely perfect. It may contain `TBD` markers, vague acceptance criteria, or implicit assumptions that only become visible on closer reading. Moving to planning with an ambiguous spec is risky — the plan inherits the ambiguity and compounds it.

`spec-clarify` exists for exactly this gap. It performs a structured analysis of your `spec.md` across nine categories of common spec weaknesses — things like undefined scope boundaries, underspecified data models, missing edge cases, and unresolved terminology. It then surfaces targeted, answerable questions that you can respond to in conversation.

Each Q&A session is recorded permanently inside the spec file under a versioned heading, so there's always an audit trail of why decisions were made. Use it whenever a spec has open questions before moving to `/spec-plan`, or when a review surfaces new concerns after the plan has already been started.

## How to use it

Trigger the skill with `/spec-clarify` followed by the spec name.

**Example — pre-planning review:**

```
/spec-clarify notification-system
```

The agent scans the spec, surfaces up to five questions, and waits for your answers. After you respond, it updates the spec file and records the session.

**Example — targeted clarification on a known issue:**

```
/spec-clarify notification-system
> I'm specifically unsure about how we handle notification preferences for deleted users
```

You can steer the session toward a known concern rather than waiting for the agent to surface it.

**Example — multiple sessions:**

Run `/spec-clarify` multiple times on the same spec as your understanding evolves. Each run creates a new `### Session N` entry in the spec.

## Reference

### Syntax

```
/spec-clarify <spec-name>
```

| Argument      | Required | Description                                                        |
| ------------- | -------- | ------------------------------------------------------------------ |
| `<spec-name>` | Yes      | Name of the spec to clarify (matches the directory under `specs/`) |

### Output

Updates `specs/<spec-name>/spec.md` in place. Each session appends a new `### Session N` block containing the questions asked and answers given.

### Behavior notes

- The skill analyzes the spec across **9 taxonomy categories**: scope boundaries, data model, UX behaviour, non-functional requirements, integrations, edge cases, terminology, completion signals, and unresolved placeholders.
- Each session surfaces up to **5 targeted, answerable questions**. The limit keeps sessions focused and conversational.
- Sessions are numbered sequentially. Session history is never overwritten.
- The skill reads the `specs/constitution.md` file if present and may surface questions related to constitutional compliance.
