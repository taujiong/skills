# Review Strategy: Agent Skills

## Dimensions

### 1. Trigger Description Quality

- The `description` field in the frontmatter must clearly state what the skill does and when it should be invoked.
- It should include representative trigger phrases (e.g. "Also triggers when users mention review my code, check code quality, or audit changes").
- It must not be so broad that it fires on unrelated requests, nor so narrow that it is never triggered.
- The description should be self-contained — an agent reading only the description can decide whether to invoke the skill.

### 2. Step Clarity & Executability

- Each step must have a clear, actionable title and unambiguous instructions.
- Shell commands must be syntactically correct and reproducible.
- Placeholders (e.g. `<project-root>`) must be defined before they are used.
- Conditional branches must cover all relevant cases (including the failure/fallback path).
- Steps must not rely on implicit state that is never set.

### 3. User Interaction Design

- Every decision point that requires user input must explicitly tell the agent to wait for the response before proceeding.
- Options presented to the user must be exhaustive and mutually exclusive.
- Error messages must be specific: include what went wrong and what the user can do about it.
- Avoid asking unnecessary questions — infer from context when possible and state what was inferred.

### 4. Idempotency & Safety

- Running the skill twice should either be safe or explicitly warn the user before overwriting state.
- Destructive operations (deletes, overwrites) must include a confirmation prompt or a clear pre-flight check.
- The skill must not silently skip important steps due to missing context.

### 5. Output Format Consistency

- If the skill produces a structured report or artifact, the format must be fully specified (headings, fields, ordering).
- Output templates must use clearly distinguishable placeholders vs. literal text.
- The skill should specify the output language behavior (follow user message language, fixed language, etc.).

### 6. Asset Hygiene

- Files bundled in `assets/` that are themselves skills must use `.template` file extensions to prevent premature registration.
- Asset files must be referenced by the correct relative path from the skill's own directory.
- Unused assets must not be present.

### 7. Completeness

- The skill must handle the full lifecycle of its task: pre-flight → execution → validation → summary.
- A validation or confirmation step should be present for skills that modify the filesystem or external state.
- The skill should not leave the repository or project in an ambiguous state upon failure.

### 8. Documentation (Skill-level)

- The skill's `SKILL.md` should be self-documenting: a new agent encountering it for the first time must understand what it does, how to invoke it, and what to expect.
- If the skill has arguments, they must be documented under `## User Input` with types, optionality, and examples.
- If the skill deploys or produces artifacts, those artifacts should be described.

---

## Severity Guidance for Agent Skills

| Finding                                                          | Typical Severity |
| ---------------------------------------------------------------- | ---------------- |
| Step references undefined placeholder / unreachable state        | P0               |
| Missing confirmation before destructive operation                | P0               |
| Trigger description too broad (fires on unrelated prompts)       | P1               |
| Conditional branch with no fallback path                         | P1               |
| User interaction point missing a "wait for response" instruction | P1               |
| Incorrect asset path reference                                   | P1               |
| Non-idempotent behavior without warning                          | P1               |
| Vague step instructions (ambiguous what agent should do)         | P2               |
| Missing argument documentation                                   | P2               |
| Output format partially specified                                | P2               |
| Template files missing `.template` extension                     | P2               |
| Minor wording / clarity issue in step                            | P3               |
