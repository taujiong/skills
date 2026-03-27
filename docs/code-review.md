# code-review

This skill guides to review git workspace changes or explicitly specified files for code quality, documentation, and skill definitions.

## When to use it

Reach for this skill whenever you want a structured review of what has changed in your working tree — before committing, before opening a pull request, or just to get a second opinion on a batch of edits. It handles source code, prose documentation, and agent skill definitions in the same run, so you don't need to pick a strategy yourself.

It's also the right choice when you're working inside a spec-driven project and want to verify that your implementation stays aligned with `spec.md`, `plan.md`, or `tasks.md`. If your project has a `specs/constitution.md`, the skill automatically enforces its principles across every file it reviews.

When there's nothing to review — no git changes and no explicit paths — the skill exits silently rather than asking for input.

## How to use it

Trigger the skill with `/code-review`, optionally followed by a scope or a focus hint.

**Review everything that has changed in the working tree:**

```
/code-review
```

**Review only what a specific commit introduced:**

```
/code-review abc1234
```

**Review changes relative to the main branch:**

```
/code-review main..HEAD
```

**Review a specific file or folder:**

```
/code-review src/auth.ts
/code-review docs/
```

**Steer the review toward a particular concern:**

```
/code-review focus on security
/code-review main..HEAD focus on performance
```

The skill figures out which content types are present (source code, documentation, skill definitions) and applies the right review strategy to each. You always get a single unified report.

## Reference

### Syntax

```
/code-review [scope] [focus]
```

| Argument | Required | Description                                                                                                                         |
| -------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `scope`  | No       | A git ref range (`main..HEAD`), a commit SHA, or a file path / glob pattern. Defaults to all staged, unstaged, and untracked files. |
| `focus`  | No       | Free-text emphasis, e.g. `"focus on security"` or `"only check the auth module"`.                                                   |

### Output

The report is always structured in this order:

```
## Code Review Report

### Summary
### ⚠ WARNING: Partial Staging Detected   (only when staged + unstaged/untracked coexist)
### Issues
  #### P0 - Critical
  #### P1 - Major
  #### P2 - Minor
  #### P3 - Suggestion
### Overall
  #### Docs Gap
  #### Config Coverage
  #### Typos
### Constitution Compliance               (only when specs/constitution.md exists)
### SDD Compliance                        (only when SDD artifacts are in scope)
  #### Spec Coverage
  #### Plan Adherence
  #### Task Completeness
### Highlights
### Next Actions                          (only when P0 or P1 issues exist)
```

Each issue line follows this format:

```
- [ ] [Group/Dimension] `file:line` — Description. **Recommendation:** ...
```

`Group` is one of: `Code`, `Docs`, `Skill`, `Overall`, `Constitution`, or `SDD`.

**Priority levels:**

| Level           | Meaning                                                                |
| --------------- | ---------------------------------------------------------------------- |
| P0 - Critical   | Must fix before merging; correctness, security, or data-integrity risk |
| P1 - Major      | Significant quality or maintainability concern                         |
| P2 - Minor      | Suggested improvement; acceptable to defer                             |
| P3 - Suggestion | Optional polish; style or micro-optimization                           |

The output language matches the language used in the triggering message.

### Behavior notes

- Files are classified into exactly one group: `skill_files` (any `SKILL.md` or `.md` inside a `skills/<name>/` subtree), `doc_files` (`.md`, `.mdx`, `.rst`, `.txt`, `.adoc` not in a skill subtree), or `code_files` (everything else).
- Every run includes project-wide **Overall** checks (Docs Gap, Config Coverage, Typos) regardless of file type.
- `specs/constitution.md`, if present, is loaded before any analysis and its rules take precedence. Constitution violations are never lower than P1.
- SDD compliance (Spec Coverage, Plan Adherence, Task Completeness) is only evaluated when `spec.md`, `plan.md`, or `tasks.md` are part of the review scope — not just present in the project.
- When both staged and unstaged/untracked changes exist, the report includes a `⚠ WARNING: Partial Staging Detected` section listing each category of files.
- If no scope is provided and no git changes are detected, the skill exits with a brief message and no report.
