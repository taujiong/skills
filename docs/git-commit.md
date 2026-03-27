# git-commit

This skill guides to automate the git commit workflow with a Conventional Commits message, auto-staging, and automatic retry on hook failures.

## When to use it

Writing good commit messages consistently is tedious, especially under time pressure. Switching between your editor and the terminal to stage files, choose a commit type, and phrase the subject in imperative mood adds friction that slows down the natural flow of work.

This skill is the right choice whenever you want to commit work — whether you just finished a feature, fixed a bug, or wrapped up a refactoring session. It's also a good fit when you're uncertain which Conventional Commits type applies, or when your project has pre-commit hooks that tend to reject commits and require manual fixing.

If you've just finished a code review or editing session and want to commit without re-explaining the changes, the skill can reuse context from the conversation instead of re-analyzing the diff.

## How to use it

Just express commit intent in natural language — no slash command is required. The skill triggers on phrases like:

```
commit my changes
help me commit
ok commit it
looks good, commit
```

**Example 1 — committing after a feature implementation:**
You've added a new login flow and haven't staged anything yet. Say "commit my changes" and the skill stages everything, analyzes the diff, and produces `feat(auth): add email/password login flow`.

**Example 2 — committing at the end of a review session:**
You spent the last few turns reviewing and editing a bug fix with the agent. Say "looks good, commit it" and the skill reuses the conversation context to generate the message without re-running `git diff`.

**Example 3 — recovering from a hook failure:**
Your project runs ESLint as a pre-commit hook. The commit fails due to lint errors. The skill automatically runs `eslint --fix`, re-stages the affected files, and retries — reporting what it did at each step.

## Reference

### Syntax

The skill is triggered by natural-language phrases. There is no slash command.

| Trigger phrase (examples)             | Notes                                                            |
| ------------------------------------- | ---------------------------------------------------------------- |
| `commit my changes`                   | Standard trigger                                                 |
| `help me commit`                      | Standard trigger                                                 |
| `ok commit it` / `looks good, commit` | Continuation trigger; reuses conversation context when available |
| `generate a commit message`           | Standard trigger                                                 |

### Output

On success, the commit hash and message are printed.

The message format follows Conventional Commits:

```
<type>(<scope>): <subject>
```

Body and footer are included only when one of these conditions applies: a breaking change must be declared, the commit bundles multiple independent concerns, the reason for the change is non-obvious and critical for future maintainers, or an issue/PR must be referenced. When body or footer content is warranted, the full message is shown and user approval is required before the commit runs.

Available commit types:

| Type       | When applied                                         |
| ---------- | ---------------------------------------------------- |
| `feat`     | New functionality visible to users or consumers      |
| `fix`      | Corrects a bug or unintended behavior                |
| `refactor` | Code restructuring with no behavior change           |
| `perf`     | Performance improvement                              |
| `test`     | Adding or updating tests                             |
| `docs`     | Documentation only                                   |
| `chore`    | Build process, tooling, dependencies, config         |
| `style`    | Formatting, whitespace, semicolons — no logic change |
| `ci`       | CI/CD pipeline changes                               |

### Behavior notes

**Auto-staging:** If the staging area is empty when the skill runs, it automatically executes `git add -A` and informs the user. This does not block execution.

**Context reuse:** If the current conversation already contains a clear summary of what was changed and the trigger phrase implies continuation, the skill skips the diff analysis and proceeds directly to message generation.

**Pre-flight checks:** Before staging or committing, the skill verifies that the working directory is inside a git repository, that the repository is not in a conflicted state (merge, rebase, cherry-pick in progress), and that there are uncommitted changes. If any check fails, the skill aborts with a specific error message and does not proceed.

**Retry on hook failure:** On a failed commit, the skill retries up to 3 times. Between attempts it applies a fix strategy based on the failure type: running autofix commands for lint/format hooks, directly editing offending files when no autofix is available, adjusting the message for hook format rejections, or surfacing failures it cannot resolve mechanically. File lock and permission errors, and mid-run merge/rebase state detections, are not retried — they are reported immediately.

**After 3 failures:** The skill stops retrying and outputs a structured summary listing what was tried in each attempt and concrete, file-specific next steps for manual resolution.
