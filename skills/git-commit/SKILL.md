---
name: git-commit
description: Guide to automate the git commit workflow. Use when users want to commit changes, stage and commit, generate a commit message, or finalize an editing session with a commit. Also triggers when users mention commit my changes, help me commit, ok commit it, or looks good commit.
---

## Execution Flow

### Step 0 — Pre-flight Checks

Run all checks in order. If any check fails, report the error and abort immediately.

1. **Inside a git repository**: Run `git rev-parse --is-inside-work-tree`. If it
   fails, abort:

   ```
   Error: Not inside a git repository.
   Run `git init` first, or navigate to a git project directory.
   ```

2. **Not in a conflicted state**: Check for in-progress operations by testing
   whether `.git/MERGE_HEAD`, `.git/rebase-merge/`, `.git/rebase-apply/`, or
   `.git/CHERRY_PICK_HEAD` exist. If any are present, abort:

   ```
   Error: Repository is in the middle of a merge/rebase/cherry-pick.
   Resolve conflicts and finalize or abort the operation first, then try again.
   ```

3. **Has uncommitted changes**: Run `git status --porcelain`. If the output is
   empty, abort:

   ```
   Error: Nothing to commit — working tree is clean.
   ```

4. **Staging area**: Run `git diff --staged --quiet`. If the staging area is
   empty (exit code 0), automatically run `git add -A` and inform the user:

   ```
   No staged changes found — automatically staged all changes with `git add -A`.
   ```

   This does not block execution — proceed to Step 1.

### Step 1 — Load Changes

**Check for reusable context first.** Skip the diff analysis if both of the
following are true:

- The current conversation already contains a code review or editing session with a clear summary of what was changed.
- The user's request implies continuation (e.g., "ok commit it", "looks good, commit") rather than a fresh request.

If context is reusable, extract the change summary from the conversation and proceed directly to Step 2.

**If new changes were made after the last review**, note the delta and ask the user whether to re-analyze or proceed with the prior context.

**Standard path** (no reusable context): Run `git diff --staged` and analyze:

- The nature of changes (new feature, bug fix, refactor, config, docs, etc.)
- The intent behind the changes — _why_ they were made, not just _what_ changed

### Step 2 — Generate Commit Message

Construct the message following conventional commits:

```
<type>: <subject>
```

**Type selection guide:**
| Type | When to use |
|---|---|
| `feat` | Introduces new functionality visible to users or consumers |
| `fix` | Corrects a bug or unintended behavior |
| `refactor` | Code restructuring with no behavior change |
| `perf` | Performance improvement |
| `test` | Adding or updating tests |
| `docs` | Documentation only |
| `chore` | Build process, tooling, dependencies, config |
| `style` | Formatting, whitespace, semicolons — no logic change |
| `ci` | CI/CD pipeline changes |

**Rules for the subject line:**

- Imperative mood: "add", "fix", "remove" — not "added", "fixes", "removing"
- No period at the end
- 72 characters max
- Default to English; use the user's language if explicitly specified

**Default: short format only (header line).** Body and footer are intentionally
omitted unless one of these conditions clearly applies:

- A breaking change must be declared (`BREAKING CHANGE:` in footer)
- The commit bundles multiple independent concerns that cannot be split
- The _reason_ for the change is non-obvious and critical for future maintainers
- An issue or PR must be referenced (`Fixes #xxx`, `Closes #xxx`)

If body/footer are needed, proceed to Step 3. Otherwise, proceed directly to Step 4.

### Step 3 — Confirm Extended Message

**MUST use the `question` tool to present options to the user.** Never execute `git commit` with a multi-line message without user confirmation.

Use the `question` tool with:

- **Question**: "How would you like to format this commit message?"
- **Header**: "Commit Message Format"
- **Options**:
  1. **Use extended message** — Include body and footer for context
  2. **Header only** — Keep it short: `<type>: <subject>`

Before presenting the question, show the prepared extended message:

```
I've prepared an extended commit message:

<type>: <subject>

<body — explains the why, not the what>

<footer — BREAKING CHANGE, Fixes #xxx, etc.>
```

- If the user chooses option 1, proceed to Step 4 with the full message.
- If the user chooses option 2, drop the body/footer and proceed to Step 4 with the header-only message.
- If the user requests changes to the message, return to Step 2 to revise.

### Step 4 — Execute Commit

- **Short message**: `git commit -m "<header>"`
- **Extended message** (approved in Step 3):

  ```bash
  git commit -m "$(cat <<'EOF'
  <type>: <subject>

  <body>

  <footer>
  EOF
  )"
  ```

On success, output the commit hash and message, then stop.

On failure, proceed to Step 5.

### Step 5 — Error Handling and Retry

Track attempt count. Maximum **3 retries** total.

On each failure:

1. Parse the error output to identify the failure type (see table below).
2. Apply the appropriate fix strategy.
3. Inform the user of what failed and what fix is being attempted.
4. Re-run the commit (return to Step 4).

**Failure types and fix strategies:**

| Failure type                                  | Fix strategy                                                                                                                                   |
| --------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| lint/format hook failure (autofix available)  | Run the autofix command reported by the hook (e.g., `eslint --fix`, `prettier --write`), re-stage affected files with `git add`, then retry    |
| lint/format hook failure (no autofix command) | Read the error details, directly edit the offending source files to resolve the reported violations, re-stage, then retry                      |
| commit message rejected by hook               | Adjust the message to satisfy the hook's requirements (e.g., length, format regex), then retry                                                 |
| type check or test failure triggered by hook  | Analyze the failure output; if the fix is mechanical (e.g., a missing import, a type annotation), apply it directly; otherwise surface to user |
| file lock or permission error                 | Do not retry; report immediately with the suggested manual resolution                                                                          |
| merge/rebase state detected mid-run           | Do not retry; report immediately                                                                                                               |

**After 3 failed attempts**, stop retrying and report:

```
Commit failed after 3 attempts. Here is a summary of what was tried and what
remains unresolved:

- Attempt 1: <what was tried> — <what failed>
- Attempt 2: <what was tried> — <what failed>
- Attempt 3: <what was tried> — <what failed>

Suggested next steps:
<concrete, actionable steps the user can take to resolve this manually>
```

Keep suggestions specific: name the files, commands, and error lines involved.
Avoid generic advice like "fix the lint errors".
