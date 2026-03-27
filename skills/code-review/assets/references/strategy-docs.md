# Review Strategy: Documentation & Comments

## Step 0 - Identify the Audience

Before applying any dimension, determine who the document is written for. The audience governs what "good" looks like for every dimension below.

Inspect the file path, frontmatter, and content to classify the primary audience:

| Audience                | Signals                                                                                                                                                                     |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Agent**               | File lives in `.agents/`, `skills/`, or `specs/`; frontmatter contains agent-specific fields (`name`, `description`, execution steps); content is imperative and procedural |
| **Human developer**     | File is a `README`, `CONTRIBUTING`, `docs/` page, inline code comment, or API reference aimed at engineers                                                                  |
| **End user / operator** | File is a user guide, runbook, CLI help text, or product documentation                                                                                                      |

If the audience is ambiguous, note it as a finding (P2) and apply the human-developer standard.

---

## Audience-specific Language Style Standards

### Writing for Agents

Agent-facing documents (skill definitions, spec files, plan files, task lists, constitution) are instructions to a non-human executor. Apply these standards:

- **Concise and unambiguous**: Every sentence should map to exactly one action or fact. Remove hedging language ("you might want to", "consider", "perhaps").
- **Imperative mood**: Use command form. "Read the file." not "The agent should read the file."
- **Formal and precise**: No colloquialisms, no filler words, no humor. Prefer explicit over implicit.
- **Structured over prose**: Use numbered lists for sequences, tables for options, code blocks for commands. Avoid multi-sentence paragraphs where a list would be clearer.
- **No redundancy**: Do not repeat the same instruction in different words. Every sentence must carry new information.
- **Self-contained references**: When referencing another file or step, use its exact name or identifier. Do not rely on context the agent may not have.
- **Examples only when necessary**: Include examples only when a concept is non-obvious or when the format of expected output must be demonstrated.

### Writing for Humans (developer or end user)

Human-facing documents need to build understanding and trust. Apply these standards:

- **Explain the why**: Describe the motivation or rationale behind decisions, not just the what. Readers learn faster when they understand intent.
- **Natural, approachable tone**: Write as you would explain to a capable colleague. Avoid jargon unless it is defined first.
- **Progressive disclosure**: Start with the common case, then cover advanced scenarios. Do not front-load edge cases.
- **Generous with examples**: Every non-trivial concept should have a concrete example. Code examples should be copy-pasteable and runnable.
- **Inclusive language**: Avoid idioms that do not translate across cultures. Avoid unnecessarily gendered language.
- **Scannable structure**: Use headings, short paragraphs, and bullet lists. A reader skimming the document should still extract the key points.

---

## Dimensions

### 1. Accuracy

- Does the documentation accurately describe the current behavior of the system?
- Are code examples syntactically correct and runnable?
- Are API signatures, parameter names, and return types consistent with the actual implementation?
- Are referenced file paths, command names, and URLs still valid?

### 2. Completeness

- Are all parameters, return values, and error conditions documented?
- Are edge cases and known limitations mentioned?
- Is there a clear entry point for the target audience (overview, quick-start, or step-by-step guide)?
- Are prerequisites and setup steps fully specified?

### 3. Clarity & Structure

- Does the writing style match the identified audience (see Audience-specific Language Style Standards above)?
- Is the structure appropriate for the audience: imperative and structured for agents; scannable and example-rich for humans?
- Is terminology consistent throughout — no synonyms for the same concept?
- Are headings and lists used to give the document a navigable structure?

### 4. Freshness

- Is the document still in sync with the codebase after the current change?
- Are there references to deprecated APIs, removed flags, or outdated workflows?
- Are version numbers or dates mentioned that may now be stale?

### 5. Formatting & Conventions

- Does the document follow the project's documentation conventions (if defined in `constitution.md`)?
- Correct use of Markdown: code fences, heading hierarchy, table formatting.
- No broken links (internal anchors, relative file paths).
- Consistent use of code formatting for inline identifiers, commands, and file paths.

### 6. Coverage of New Changes

When source code changes are also present in the review scope, check whether:

- New public APIs added in this change have corresponding documentation.
- Changed behavior is reflected in the docs.
- Deleted or renamed APIs have their documentation removed or updated.

---

## Severity Guidance for Documentation

| Finding                                                                               | Typical Severity |
| ------------------------------------------------------------------------------------- | ---------------- |
| Factually incorrect information (wrong API, broken example)                           | P1               |
| Missing documentation for new public API surface                                      | P1               |
| Stale references that would mislead a reader                                          | P1               |
| Audience mismatch (agent doc written like prose; human doc written like instructions) | P1               |
| Incomplete parameter or error documentation                                           | P2               |
| Structural / clarity issue (hard to follow for target audience)                       | P2               |
| Missing "why" explanation in human-facing doc                                         | P2               |
| Missing example for non-trivial concept in human-facing doc                           | P2               |
| Redundancy or hedging language in agent-facing doc                                    | P2               |
| Minor formatting or convention violation                                              | P3               |
| Typo or grammar issue                                                                 | P3               |
