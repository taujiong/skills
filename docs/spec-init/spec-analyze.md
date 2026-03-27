# spec-analyze

This skill guides to audit all spec artifacts for consistency, coverage, and constitution compliance.

## When to use it

After you've gone through specify → plan → tasks, you have four documents that need to agree with each other. In practice, they often don't — a requirement slips out of the plan, a task has no corresponding spec story, or the language used in the plan drifts from the terminology in the spec. Catching these issues after implementation has started is expensive.

`spec-analyze` is a read-only consistency checker that audits all four artifacts — `spec.md`, `plan.md`, `tasks.md`, and `constitution.md` — against each other before any code is written. It finds duplication, ambiguity, underspecification, coverage gaps (requirements with no tasks), and terminology drift between documents. Results are presented as a severity-ranked table so you know what to fix first.

This is an optional step, but running it before `/spec-implement` gives you a last checkpoint to surface issues while they're still cheap to fix. It's especially valuable when a spec has gone through multiple clarification sessions or the plan has been updated after initial review.

## How to use it

Trigger the skill with `/spec-analyze` followed by the spec name.

**Example — pre-implementation validation:**

```
/spec-analyze notification-system
```

The agent reads all four artifacts and returns a findings table ranked by severity.

**Example — checking after a plan update:**

```
/spec-analyze notification-system
> The plan was updated — I want to make sure tasks.md still covers everything
```

Run it any time you want to verify that all artifacts are in sync, not just before implementation.

## Reference

### Syntax

```
/spec-analyze <spec-name>
```

| Argument      | Required | Description                                                        |
| ------------- | -------- | ------------------------------------------------------------------ |
| `<spec-name>` | Yes      | Name of the spec to analyze (matches the directory under `specs/`) |

### Output

Returns a severity-ranked findings table. Severity levels: `CRITICAL`, `HIGH`, `MEDIUM`, `LOW`. Each finding includes:

- The artifact(s) involved
- A description of the inconsistency or gap
- A recommended remediation command or action

The table is capped at 50 rows.

### Behavior notes

- This skill is **read-only** — it does not modify any artifact files.
- It detects: duplication, ambiguity, underspecification, constitution violations, requirement coverage gaps (requirements in `spec.md` with no corresponding tasks in `tasks.md`), and terminology drift between documents.
- If `constitution.md` is not present, the compliance check portion of the analysis is skipped.
- If any of `spec.md`, `plan.md`, or `tasks.md` are missing, the skill analyzes what is available and notes the missing files in its report.
