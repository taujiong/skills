# spec-implement

This skill guides to execute a task checklist phase by phase, driving the full implementation.

## When to use it

Once you have a stable `tasks.md`, the implementation work is well-defined. But working through a long checklist manually — keeping track of what's done, handling errors, writing tests before implementation, committing at the right intervals — is tedious and error-prone.

`spec-implement` takes over this execution loop. It reads `tasks.md`, picks up from the first incomplete task, drives the agent through each phase in order (following TDD: tests fail first, then implementation makes them pass), and commits each completed phase using Conventional Commits format. If something goes wrong, the skill self-corrects up to three times before escalating to you.

Use this skill when `tasks.md` is ready and you're prepared to let the agent take the wheel. You can scope execution to a single story or phase if you want to proceed incrementally, or let it run end-to-end for fully automated delivery.

## How to use it

Trigger the skill with `/spec-implement` followed by the spec name.

**Example — full implementation run:**

```
/spec-implement notification-system
```

The agent starts from the first incomplete task and runs through all phases.

**Example — resuming after an interruption:**

```
/spec-implement notification-system
```

The skill automatically detects already-completed tasks and resumes from where it left off. No special flag needed.

**Example — scoping to a single phase:**

```
/spec-implement notification-system --phase foundational
```

**Example — scoping to a single user story:**

```
/spec-implement notification-system --story "User receives email alert"
```

## Reference

### Syntax

```
/spec-implement <spec-name> [--story <story-name>] [--phase <phase-name>]
```

| Argument               | Required | Description                                                                                      |
| ---------------------- | -------- | ------------------------------------------------------------------------------------------------ |
| `<spec-name>`          | Yes      | Name of the spec to implement (matches the directory under `specs/`)                             |
| `--story <story-name>` | No       | Scope execution to tasks for a specific user story                                               |
| `--phase <phase-name>` | No       | Scope execution to a specific phase (`setup`, `foundational`, `per-user-story`, `cross-cutting`) |

### Output

- Modifies project source files according to the tasks in `tasks.md`.
- Updates checkboxes in `tasks.md` as tasks are completed.
- Creates a git commit in **Conventional Commits** format at the end of each completed phase.

### Behavior notes

- The skill automatically resumes from the first incomplete task when re-invoked — there is no need to track progress manually.
- TDD-aware: for each test/implementation pair, the skill runs the test, expects it to fail (RED), writes the implementation, then expects it to pass (GREEN). It does not skip the RED step.
- On errors, the skill applies up to **3 self-correction attempts** before pausing and reporting the failure to the user with context.
- `--story` and `--phase` can be combined to further narrow the scope of a run.
- Commits are only created when a phase completes fully. Partial phases do not produce commits.
