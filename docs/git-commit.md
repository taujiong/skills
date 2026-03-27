# git-commit

Automate the git commit workflow with a [Conventional Commits](https://www.conventionalcommits.org/) message, auto-staging, and automatic retry on hook failures.

## Usage

The skill triggers automatically — no slash command needed. Just express commit intent in natural language:

```prompt
commit my changes
help me commit
ok commit it, looks good
```

If nothing is staged, all changes are staged automatically via `git add -A`.

## Output

On success, the commit hash and message are printed. The message format is:

```text
<type>(<scope>): <subject>
```

Body and footer are added only when necessary (breaking changes, issue references, or non-obvious rationale). For extended messages, the skill shows a preview and waits for approval before committing.

## Error Handling

On hook or lint failures, the skill retries up to **3 times**, auto-applying fixes (e.g., `eslint --fix`, editing offending files directly) between attempts. After 3 failures, a structured summary with specific next steps is reported.
