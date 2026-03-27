---
name: spec-init
description: Deploy spec-driven development (SDD) skills and runtime directories to a project. Use when users want to initialize or set up the SDD workflow in a specific directory. Also triggers when users mention init sdd, setup sdd, initialize spec workflow, or bootstrap spec-driven development.
---

## User Input

```text
$ARGUMENTS
```

## Execution Flow

### Step 0 - Pre-flight Checks

Run all checks below in order. If any check fails, report the corresponding error and abort immediately.

1. **Resolve project root**: If the input provides a path, use it as the project root. If the input is empty, infer the target project root from the conversation context. If still unclear, default to the current working directory. Verify the resolved directory exists. If not, abort:

   ```text
   Error: Project root directory does not exist: <project-root>
   ```

2. **Derive target paths** from the resolved project root:
   - Skills directory: `<project-root>/.agents/skills/spec/`
   - Runtime directory: `<project-root>/specs/inbox/`

3. **Skills directory conflict**: Check whether `<project-root>/.agents/skills/spec/` already exists and contains files. If it does, ask the user:

   ```text
   SDD skills already exist at <project-root>/.agents/skills/spec/.

   Options:
     A - Overwrite: replace all skill files with the latest version
         (preserves specs/ runtime data)
     B - Abort
   ```

   Wait for the user's decision. If the user chooses B, abort.

4. **Runtime directory state**: Check whether `<project-root>/specs/inbox/` already exists. Record the result as `inbox_exists` for use in Step 2.

### Step 1 - Deploy Skill Files

Copy all 7 SDD skill directories from this skill's bundled [assets/spec/](assets/spec/) directory to the target skills directory, then restore the template files to their runtime names.

The bundled assets use `.template` suffixes on skill definition files (`SKILL.md.template`) to prevent the agent runtime from registering them as active skills. During deployment, rename them back to `SKILL.md`.

```sh
mkdir -p <project-root>/.agents/skills/spec
cp -r <current-skill-dir>/assets/spec/* <project-root>/.agents/skills/spec/
find <project-root>/.agents/skills/spec -name "SKILL.md.template" -exec sh -c 'mv "$1" "$(dirname "$1")/SKILL.md"' _ {} \;
```

### Step 2 - Create Runtime Directory

If `inbox_exists` is false (from Step 0), create the inbox directory and copy the README:

```sh
mkdir -p <project-root>/specs/inbox
cp <current-skill-dir>/assets/inbox-README.md <project-root>/specs/inbox/README.md
```

If `inbox_exists` is true, skip this step — do not overwrite existing files in `specs/`, as users may have active spec data there.

### Step 3 - Validate

Verify the deployment is complete:

- [ ] 7 skill directories exist under `<project-root>/.agents/skills/spec/`: `spec-analyze`, `spec-clarify`, `spec-constitution`, `spec-implement`, `spec-plan`, `spec-specify`, `spec-tasks`
- [ ] Each skill directory contains a `SKILL.md` file (no residual `SKILL.md.template` files remain)
- [ ] Template asset files exist: `spec-constitution/assets/constitution-template.md`, `spec-plan/assets/plan-template.md`, `spec-plan/assets/plan-examples.md`, `spec-specify/assets/spec-template.md`, `spec-tasks/assets/tasks-template.md`
- [ ] `<project-root>/specs/inbox/README.md` exists

If any check fails, report the specific failure and suggest re-running `/spec-init`.

### Step 4 - Summarize

Report the deployment result:

```text
SDD workflow initialized at <project-root>.

Skills deployed to: <project-root>/.agents/skills/spec/
  - spec-analyze, spec-clarify, spec-constitution, spec-implement,
    spec-plan, spec-specify, spec-tasks

Runtime directory: <project-root>/specs/inbox/ [created / already existed]

Available commands:
  /spec-specify <description>    Create a new specification
  /spec-clarify <spec-name>      Clarify ambiguities in a spec
  /spec-plan <spec-name>         Generate an implementation plan
  /spec-tasks <spec-name>        Generate implementation tasks
  /spec-analyze <spec-name>      Validate cross-artifact consistency
  /spec-implement <spec-name>    Execute the implementation
  /spec-constitution             Define project-wide principles

Recommended first step: Run /spec-constitution to define your project's
development standards, or /spec-specify to create your first specification.
```
