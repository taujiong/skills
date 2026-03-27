# Documentation Guide

## Structure

Every skill document follows the Diátaxis framework: three ordered sections that serve distinct reader needs.

1. **Concept** — explains _why_ the skill exists and _when_ to reach for it (explanation)
2. **Usage** — shows _how_ to use the skill in real scenarios (how-to)
3. **Reference** — describes _what_ the skill accepts and produces, precisely (reference)

Never mix sections: do not put step-by-step instructions inside a Reference table, and do not embed full parameter specs inside a how-to example.

## Standard Template (regular skill)

Use this template for every skill that does one focused thing.

```markdown
# <skill-name>

This skill guides to [concise description of what it does for the user].

## When to use it

> Explain the problem this skill solves and the situations in which it is the right choice.
> This section answers "why" and "when", not "how". Two to four short paragraphs is typical.

## How to use it

> Describe how to trigger the skill. Show one to three realistic examples that represent different common goals. Focus on the user's intent, not on exhaustive option coverage.

## Reference

### Syntax

> Command syntax, argument table, or trigger phrases.

### Output

> Describe the structure and format of the skill's output, if it follows a fixed schema.

### Behavior notes

> Boundary conditions, defaults, error handling, and other precise behavioral facts.
> Write neutrally — describe, do not recommend.
```

### Rules for each section

**`# <skill-name>` and the opening line**

- The line immediately after the `h1` heading must follow this exact pattern:
  `This skill guides to <verb phrase>.`
- Keep it to one sentence. Do not add a second sentence on the same line.

**When to use it**

- Answer: what problem does this solve? In what situation should I reach for this skill?
- Do not include steps or commands here.
- Link to related skills or concepts where relevant.

**How to use it**

- Lead with the trigger (slash command or natural-language phrase).
- Show examples first; explain variations after.
- Do not reproduce the full parameter table here — save that for Reference.

**Reference**

- Write in neutral, factual language. No recommendations, no opinions.
- Omit subsections that do not apply (e.g. if output has no fixed schema, skip "Output").
- Keep tables concise: include only the details a working user actually needs to look up.

---

## Meta-skill template

A meta-skill is a skill whose primary function is to bootstrap or coordinate a suite of other skills (e.g. `spec-init`). Its documentation lives in a subdirectory.

### Directory layout

```
docs/
  <meta-skill-name>/
    README.md               ← meta-skill doc (this template)
    <child-skill-1>.md      ← child skill doc (standard template)
    <child-skill-2>.md
    ...
```

### README.md template

```markdown
# <meta-skill-name>

This skill guides to [concise description of what the suite does for the user].

## Why this workflow exists

> Explain the underlying problem that motivated this suite. Describe the discipline or approach it encodes and why it produces better outcomes. This is the most important section in a meta-skill doc — give it room to breathe.

## How to get started

> Explain what the user must do once to set up the suite (e.g. run /meta-skill-name).
> Keep it short: one trigger, one outcome sentence.

## Workflow

> Show the typical end-to-end sequence of child skills. A diagram is encouraged.
> Explain the role of each step and why the order matters.

## Skills in this suite

> A brief table or list: skill name + one-sentence description + link to its doc.
> Do not reproduce full skill docs here — link to them.
```

### Rules for meta-skill docs

- `README.md` focuses on the **workflow** — how the child skills fit together.
- Each child skill gets its **own file** using the standard template.
- Do not duplicate child skill detail in `README.md`; link to the child doc instead.
- The "Why this workflow exists" section carries more weight here than in a regular skill doc — it is the reader's motivation to adopt the whole suite.
