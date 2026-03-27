# code-review

Perform a comprehensive review of a git workspace or explicitly specified files. The skill adapts its review strategy based on the type of content changed, runs a project-wide overall check on every invocation, and always enforces project-level principles when `specs/constitution.md` is present.

## Invocation

```prompt
/code-review [scope] [focus]
```

| Argument | Required | Description                                                                                                                                         |
| -------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `scope`  | No       | A git ref range (`main..HEAD`), a commit SHA, or an explicit file path / glob pattern. Defaults to all staged, unstaged, and untracked (new) files. |
| `focus`  | No       | Free-text emphasis, e.g. `"focus on security"` or `"only check the auth module"`.                                                                   |

**Examples:**

```prompt
/code-review
/code-review main..HEAD
/code-review abc1234
/code-review src/auth.ts
/code-review docs/
/code-review focus on performance
```

If no scope is provided and no git changes are detected, the skill exits silently with a brief message. Two scenarios trigger this:

- **No changes:** "No changes detected in the working tree and no review target specified. Nothing to review."
- **Not a git repo:** "Not a git repository and no review target specified. Nothing to review."

The skill never prompts for input.

## What Gets Reviewed

The skill classifies every file in scope into one of three content type groups and applies the matching review strategy:

| Group             | Matched files                                                                       | Strategy            |
| ----------------- | ----------------------------------------------------------------------------------- | ------------------- |
| **Source Code**   | Programming language files (`.ts`, `.py`, `.go`, `.java`, `.rs`, etc.)              | `strategy-code.md`  |
| **Documentation** | Prose files (`.md`, `.mdx`, `.rst`, `.txt`, `.adoc`) that are not skill definitions | `strategy-docs.md`  |
| **Agent Skills**  | `SKILL.md` files and their assets inside `skills/` directories                      | `strategy-skill.md` |

A single review run can cover all three groups simultaneously.

## Overall Review

In addition to per-type analysis, every run includes a project-wide pass that is independent of content type:

- **Docs Gap** — checks whether new modules, packages, or major features have a corresponding entry in `README.md` or `docs/`.
- **Config Coverage** — checks whether global config files (lint, format, pre-commit hooks, CI pipelines) need updating to cover new file types or tools introduced by the changes.
- **Typos** — scans all changed files for spelling mistakes in identifiers, strings, comments, and documentation.

## Cross-cutting Checks

Two additional checks are applied to all content types:

### Constitution Compliance

If `specs/constitution.md` exists at the project root, it is read before any other analysis and its principles are enforced across every changed file. Constitution rules take precedence over the default strategy checklists. Violations are always rated P1 or higher.

### SDD Compliance

If any of `spec.md`, `plan.md`, or `tasks.md` are **included in the current review scope** (not a global project search), the skill evaluates:

- **Spec coverage** — are all requirements implemented?
- **Plan adherence** — does the implementation match the architectural decisions?
- **Task completeness** — do task statuses in `tasks.md` reflect the actual changes?

## Output Format

The report is structured and priority-ordered:

```
## Code Review Report

### Summary
### ⚠ WARNING: Partial Staging Detected  (only when staged + unstaged/untracked coexist)
### Issues
  #### P0 - Critical
  #### P1 - Major
  #### P2 - Minor
  #### P3 - Suggestion
### Overall
  #### Docs Gap
  #### Config Coverage
  #### Typos
### Constitution Compliance   (only when specs/constitution.md exists)
### SDD Compliance            (only when SDD artifacts exist)
  #### Spec Coverage
  #### Plan Adherence
  #### Task Completeness
### Highlights
### Next Actions              (only when P0 or P1 issues exist)
```

Each issue follows the format:

```
- [ ] [Group/Dimension] `file:line` — Description. **Recommendation:** ...
```

Where `Group` is one of `Code`, `Docs`, `Skill`, `Overall`, `Constitution`, or `SDD`.

### Priority Levels

| Level               | Meaning                                                                |
| ------------------- | ---------------------------------------------------------------------- |
| **P0 - Critical**   | Must fix before merging; correctness, security, or data-integrity risk |
| **P1 - Major**      | Strongly recommended; significant quality or maintainability concern   |
| **P2 - Minor**      | Suggested improvement; acceptable to defer                             |
| **P3 - Suggestion** | Optional polish; style or micro-optimization                           |

The output language follows the language used in the user's message.

## Review Strategies

Detailed checklists for each content type are defined in the skill's reference files:

- [`assets/references/strategy-code.md`](../skills/code-review/assets/references/strategy-code.md) — naming, design principles, clean architecture, security, performance (constitution.md takes precedence where rules conflict)
- [`assets/references/strategy-docs.md`](../skills/code-review/assets/references/strategy-docs.md) — audience detection, language style, accuracy, completeness, freshness, formatting
- [`assets/references/strategy-skill.md`](../skills/code-review/assets/references/strategy-skill.md) — trigger quality, step clarity, idempotency, asset hygiene, output format
