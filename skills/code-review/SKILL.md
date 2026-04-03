---
name: code-review
description: Guide to perform a comprehensive review on git workspace changes or explicitly specified content. Use when users want to review source code, documentation/comments, or agent skill definitions. Also triggers when users mention review my code, review changes, review commits, audit code quality, check code quality, inspect code, or review skill.
---

## User Input

```text
$ARGUMENTS
```

Optional arguments:

- A git ref range (e.g. `main..HEAD`, a commit SHA) to override the default diff scope.
- A file path or glob pattern to review specific files explicitly (e.g. `src/auth.ts` or `docs/`).
- Free-text focus areas (e.g. "focus on security") to emphasize specific dimensions.

## Execution Flow

### Step 0 - Pre-flight Checks

1. **Determine review scope** using the following decision tree:

   a. If the user explicitly provided file paths or glob patterns in `$ARGUMENTS`, use them as the review scope. Skip git detection entirely.

   b. Otherwise, attempt to detect a git repository:

   ```sh
   git rev-parse --is-inside-work-tree
   ```

   - If **inside a git repo**: collect changed files via:

     ```sh
     git diff HEAD --name-only
     git diff --cached --name-only
     git ls-files --others --exclude-standard
     ```

     Merge and deduplicate all three lists into a single review scope. If the user provided a git ref range or commit SHA in `$ARGUMENTS`, use that instead of `HEAD` for the first two commands. The third command (`git ls-files --others`) always collects all untracked files in the working tree regardless of ref range, because untracked files have no git history to diff against.

     If the combined list is empty, output:

     ```text
     No changes detected in the working tree and no review target specified. Nothing to review.
     ```

     Then exit silently.

     Otherwise, record `has_staged`, `has_unstaged`, and `has_untracked` flags:

     ```sh
     git diff --cached --name-only   # non-empty → has_staged = true
     git diff HEAD --name-only       # non-empty → has_unstaged = true
     git ls-files --others --exclude-standard  # non-empty → has_untracked = true
     ```

     Set `has_partial_scope = true` if `has_staged` is true AND (`has_unstaged` OR `has_untracked`) is also true. This means the working tree contains changes outside the staged snapshot that are still included in the review scope. Record this flag — it will be surfaced as a WARNING in the report.

   - If **not inside a git repo** and no explicit paths were provided, output:

     ```text
     Not a git repository and no review target specified. Nothing to review.
     ```

     Then exit silently.

2. **Detect constitution**: Look for `specs/constitution.md` relative to the project root. Record as `has_constitution`. If found, read it immediately — its principles apply to **all** content types reviewed in this session.

3. **Detect SDD artifacts**: Check whether the review scope includes any of the following files (i.e. they are among the files being reviewed, not a global project search). Record:
   - `has_spec` — `spec.md` is in the review scope
   - `has_plan` — `plan.md` is in the review scope
   - `has_tasks` — `tasks.md` is in the review scope

   Set `has_sdd = true` if any of the above is true.

4. **Classify files** in the review scope into content type groups (a file belongs to only one group; use the first matching rule):

   | Group         | Match condition                                                                                                  |
   | ------------- | ---------------------------------------------------------------------------------------------------------------- |
   | `skill_files` | Path contains `SKILL.md`, or file is a `.md` file inside the same `skills/<skill-name>/` subtree as a `SKILL.md` |
   | `doc_files`   | Extension is `.md`, `.mdx`, `.rst`, `.txt`, `.adoc` and not classified as `skill_files`                          |
   | `code_files`  | All remaining files (source code, config, scripts, etc.)                                                         |

   Record the three lists. Empty groups are fine.

### Step 1 - Load Review Strategies

Load the applicable strategy reference documents from this skill's `assets/references/` directory based on which groups are non-empty:

- `code_files` non-empty → load [`assets/references/strategy-code.md`](assets/references/strategy-code.md)
- `doc_files` non-empty → load [`assets/references/strategy-docs.md`](assets/references/strategy-docs.md)
- `skill_files` non-empty → load [`assets/references/strategy-skill.md`](assets/references/strategy-skill.md)

These documents define the exact dimensions and severity guidance to apply. Do not invent dimensions outside of what the loaded strategies define (except for Constitution and SDD compliance, which are always applied when detected).

### Step 2 - Read File Contents

1. For each file in all groups, read the complete file content to understand context.
2. If `has_sdd` is true, read each detected SDD file in full (`spec.md`, `plan.md`, `tasks.md`).

### Step 3 - Analyze

For each content type group, apply the corresponding loaded strategy. For each finding, record:

- **Group** (`[Code]`, `[Docs]`, or `[Skill]`)
- **Dimension** (from the strategy document, e.g. `Code Quality`, `Security`, `Accuracy`)
- **Severity** (P0 / P1 / P2 / P3)
- **Location** (`file:line` where applicable)
- **Description** of the problem
- **Recommendation** for how to fix or improve it

In addition, always apply the following two cross-cutting checks regardless of content type:

**Constitution Compliance** (`has_constitution` only):

- Re-read every changed file against each principle in `constitution.md`.
- Flag any violation by quoting the exact constitution clause that is breached.
- Constitution violations are never lower than P1.

**SDD Compliance** (`has_sdd` only):

- Spec coverage: map each requirement in `spec.md` to its implementation.
- Plan adherence: verify the implementation structure matches `plan.md`'s design decisions.
- Task completeness: cross-reference `tasks.md` task status against the actual changes.

### Step 3b - Overall Review

Perform the following checks across the entire review scope, independent of content type. These checks look at the project as a whole rather than individual files.

**Documentation Gap**:

- For each new module, package, service, or major feature introduced in the changed files, check whether a corresponding entry exists in `README.md` or under a `docs/` directory. Flag any new top-level addition that has no documentation counterpart.
- If existing docs are present but the new addition is not mentioned, note the specific file and section that should be updated.

**Global Configuration Coverage**:

- Scan for project-wide config files that may need updating to cover new file types or new tools introduced by the changes: `.eslintrc`, `.prettierrc`, `pyproject.toml`, `lefthook.yaml`, `.pre-commit-config.yaml`, `Makefile`, CI pipeline files, and similar.
- Example: if new `.graphql` files are introduced but the lint/format config has no rule for that extension, flag it.
- Example: if a new language is added to the project but the pre-commit hook has no formatter for it, flag it.

**Typos & Trivial Errors**:

- Scan all changed files for spelling mistakes in identifiers, string literals, comments, and documentation.
- Flag obvious typos (e.g. `recieve`, `teh`, `inital`) as P3.
- Do not flag domain-specific abbreviations or intentional shorthand.

Record findings from this step using Group = `Overall` and the appropriate dimension label (`Docs Gap`, `Config Coverage`, or `Typo`).

### Step 4 - Produce Report

Produce the final report using the template below. The output language must match the language used in the user's message.

Severity definitions:

| Level           | Meaning                                                                     |
| --------------- | --------------------------------------------------------------------------- |
| P0 - Critical   | Must fix before merging; correctness, security, or data-integrity risk      |
| P1 - Major      | Strongly recommended to fix; significant quality or maintainability concern |
| P2 - Minor      | Suggested improvement; acceptable to defer but worth tracking               |
| P3 - Suggestion | Optional polish; style, micro-optimization, or nice-to-have                 |

Each issue follows this format:

```markdown
- P[S].[N]
  - **type**: [Group/Dimension]
  - **location**: `file:line`
  - **description**:
  - **recommendation**:
```

Where `S` is the severity level (0–3), `N` is the sequential issue number within that severity, `Group` is one of `Code`, `Docs`, `Skill`, `Overall`, `Constitution`, or `SDD`, and `Dimension` is the specific dimension name from the loaded strategy or overall check (e.g. `Security`, `Accuracy`, `Trigger Description`, `Docs Gap`, `Config Coverage`, `Typo`).

---

**Report template:**

```markdown
## Code Review Report

### Summary

<1-3 sentences: what was reviewed, how many files, which content type groups are present (Code / Docs / Skill),
and the overall quality signal.>

Content types reviewed: <Code | Docs | Skill — list all that apply>
Files reviewed: <count>

---

### ⚠ WARNING: Partial Staging Detected

> Include this section only when `has_partial_scope` is true. Omit entirely otherwise.

The review scope includes **both staged and unstaged/untracked changes**. This means the working tree does not match what would be committed if you ran `git commit` right now.

| Category                    | Files                                                  |
| --------------------------- | ------------------------------------------------------ |
| Staged (will be committed)  | <list from `git diff --cached --name-only`>            |
| Unstaged modifications      | <list from `git diff HEAD --name-only` minus cached>   |
| Untracked (new, not staged) | <list from `git ls-files --others --exclude-standard`> |

**Recommendation:** If you intend to review only what will be committed, run `git stash -u` to shelve unstaged and untracked changes before review, or use `/code-review --cached` scope. The current report covers **all** of the above.

---

### Issues

> Issues are grouped by severity, then by file within each severity level.
> Format:
>
> - P[S].[N]
>   - **type**: [Group/Dimension]
>   - **location**: `file:line`
>   - **description**:
>   - **recommendation**:

#### P0 - Critical

<issues, or "None">

#### P1 - Major

<issues, or "None">

#### P2 - Minor

<issues, or "None">

#### P3 - Suggestion

<issues, or "None">

---

### Overall

> Findings from the project-wide review (Step 3b). Always include this section.

#### Docs Gap

<List of new modules/features missing documentation, with specific files that need updating. Or "None".>

#### Config Coverage

<List of global config files that need updating to cover new file types or tools. Or "None".>

#### Typos

<List of spelling mistakes found across all changed files. Or "None".>

---

### Constitution Compliance

> Include this section only when `has_constitution` is true.

<For each violation, quote the breached clause and describe the issue using the issue line format above,
with Group = "Constitution". If no violations: "All changes comply with the defined constitution principles.">

---

### SDD Compliance

> Include this section only when `has_sdd` is true.

#### Spec Coverage

> Include only when `has_spec` is true.

List each requirement from `spec.md` and its implementation status:

- [x] Requirement A — implemented in `file:line`
- [ ] Requirement B — not yet implemented

#### Plan Adherence

> Include only when `has_plan` is true.

Assess whether the implementation follows the architecture in `plan.md`. Note any deviations or unexplained divergences.

#### Task Completeness

> Include only when `has_tasks` is true.

Cross-reference `tasks.md` task status with actual changes. Flag tasks marked done but missing implementation,
or changes not tied to any task.

---

### Highlights

<2-5 bullets of specific, genuine positive observations — not generic praise. Reference file:line where relevant.>

---

### Next Actions

<Ordered list of follow-up steps, prioritized by severity. Omit this section entirely if there are no P0 or P1 issues.>
```

### Step 5 - Deliver

Output the completed report in full. Do not truncate any section. If a section has no findings, write "None" rather than omitting it. Exception: the Constitution, SDD, and their sub-sections are omitted entirely when the corresponding flag is false.
