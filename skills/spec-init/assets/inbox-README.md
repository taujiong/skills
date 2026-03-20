# External Resource Inbox

This directory serves as a **temporary drop zone** for external resources that inform the spec-driven development (SDD) workflow. Files placed here are automatically discovered and consumed by SDD skills during execution.

## Lifecycle

1. User places external resource files in this directory.
2. `spec-specify` discovers all files (excluding `README.md`) during its Resource Discovery step.
3. Discovered files are **moved** (not copied) to `specs/<spec-name>/refs/` after the spec directory is created.
4. After consumption, this directory MUST contain only this `README.md` file.

Subsequent SDD stages (`spec-clarify`, `spec-plan`, `spec-tasks`, `spec-implement`) read resources from `specs/<spec-name>/refs/` — never from this inbox directory.

## Resource Type Convention

All resource files MUST be Markdown (`.md`) files. Each resource type is identified by a **file name suffix** before the `.md` extension. Other file formats (images, YAML, Protobuf, etc.) MUST NOT be placed directly in this directory — instead, reference them from within the corresponding `.md` file using standard Markdown links or embeds.

Each type is bound to exactly one suffix and is consumed at specific SDD stages.

| Type     | Suffix Pattern  | Example File Names                                  | Consumed By            | Purpose                                                              |
| -------- | --------------- | --------------------------------------------------- | ---------------------- | -------------------------------------------------------------------- |
| PRD      | `*.prd.md`      | `login.prd.md`, `v2.prd.md`                         | specify, clarify       | Business goals, user roles, feature scope, priorities                |
| Design   | `*.design.md`   | `login.design.md`, `dashboard.design.md`            | specify, plan          | UI layout, interaction flows, state transitions, component structure |
| Contract | `*.contract.md` | `user-service.contract.md`, `order-api.contract.md` | plan, tasks, implement | API endpoints, request/response schemas, error codes                 |

## Adding New Resource Types

To extend this convention with a new resource type:

1. Choose a descriptive type name (lowercase, single word).
2. Bind a suffix: `*.<type>.md` (e.g., `*.test-plan.md`).
3. Determine which SDD stages consume this resource:
   - Affects **what** to build (scope, requirements, user journeys) -> specify, clarify
   - Affects **how** to build (architecture, tech decisions, data models) -> plan
   - Affects **concrete implementation steps** (specific code to write) -> tasks, implement
4. Add a row to the Resource Type Convention table above.
