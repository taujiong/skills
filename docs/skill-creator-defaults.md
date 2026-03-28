# skill-creator-defaults

This skill guides to enforce project-specific conventions whenever a skill is being created or edited.

## When to use it

When creating skills without a dedicated project setup, decisions like where to save the skill, what tone to write in, and how to format the description are often left implicit — leading to inconsistency across skills. This skill captures those decisions once so they are applied automatically every time skill-creator runs.

It is the right choice whenever you are creating or editing a skill in this project and want consistent placement, writing quality, and description format without having to remember the conventions manually.

## How to use it

The skill triggers automatically alongside skill-creator. No explicit invocation is needed.

**Example — creating a new skill without specifying a path:**
You say "create a skill that helps me review pull requests". The skill ensures the output is placed at `.agents/skills/code-review/` in the current working directory, written in imperative agent-facing language, with a description following the standard three-part format.

## Reference

### Default output location

If no path is specified by the user, skills are saved to:

```
<project_root>/.agents/skills/<skill-name>/
```

`<project_root>` is the current working directory at the time of creation.

### Writing style

| Dimension   | Requirement                                             |
| ----------- | ------------------------------------------------------- |
| Conciseness | Omit filler words and redundant explanation             |
| Precision   | Use unambiguous, specific terminology                   |
| Voice       | Imperative ("Do X", not "You should do X")              |
| Register    | Formal; no colloquialisms, contractions, or casual tone |

### Description format

The `description` field in SKILL.md frontmatter must follow this exact structure:

```
Guide to <what the skill does>. Use when users want to <primary use cases>. Also triggers when users mention <trigger keywords or phrases>.
```
