---
name: skill-creator-defaults
description: Guide to project-specific defaults for skill creation. Use anytime skill-creator is active or when users want to create, write, or save a skill. Also triggers when users mention skill output location, skill writing style, or skill description format.
---

# Skill Creator — Project Defaults

Apply these conventions whenever creating or editing a skill in this project.

## Default Output Location

If the user does not specify an output path, save the skill to:

```
<project_root>/.agents/skills/<skill-name>/
```

`<project_root>` is the current working directory.

## Writing Style

Skills are written for agents. Follow these standards:

- **Concise**: omit filler words and redundant explanation
- **Precise**: use unambiguous terminology; prefer specific terms over general ones
- **Imperative**: use command form ("Do X", not "You should do X" or "X can be done")
- **Formal**: avoid colloquialisms, contractions, and conversational tone

## Description Format

Always use this exact three-part format for the `description` field in SKILL.md frontmatter:

```
Guide to <what the skill does>. Use when users want to <primary use cases>. Also triggers when users mention <trigger keywords or phrases>.
```

**Example:**

```
Guide to automate the git commit workflow. Use when users want to commit changes, stage and commit, or generate a commit message. Also triggers when users mention commit my changes, help me commit, ok commit it, or looks good commit.
```
