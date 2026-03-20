# Tasks: [SPEC NAME]

## Setup (Shared Infrastructure)

<!-- Skip this phase if plan.md contains no new project setup work. -->

**Purpose**: Project initialization and basic structure

<!-- GENERATE_TASKS_HERE -->

## Foundational (Blocking Prerequisites)

<!-- Skip this phase if plan.md contains no cross-story dependencies or shared models. -->

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**CRITICAL**: No user story work can begin until this phase is complete.

<!-- GENERATE_TASKS_HERE -->

**Checkpoint**: Foundation ready — user story implementation can now begin.

## US[N]: [Title] (Priority: P[N]) [MVP_MARKER]

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for US[N]

> Write these tests FIRST and ensure they FAIL before implementation.

<!-- GENERATE_TASKS_HERE -->

### Implementation for US[N]

<!-- GENERATE_TASKS_HERE -->

**Checkpoint**: US[N] should be fully functional and testable independently.

<!-- Repeat for each user story from spec.md, in priority order (P1, P2, P3...). Use heading format "## US[N]: [Title] (Priority: P[N])". Mark the first user story phase with "MVP" marker. -->

## Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories and constitutional compliance verification

<!-- constitution:begin -->
<!-- This section is managed by spec-constitution. Do not edit manually between these markers. -->
<!-- Run /spec-constitution to update when the project constitution changes. -->
<!-- constitution:end -->

<!-- GENERATE_TASKS_HERE: Quality gates and cross-cutting verification tasks -->

## Dependencies & Execution Order

### Phase Dependencies

<!-- Derive dependencies from the phases generated above. -->

### User Story Dependencies

<!-- Derive inter-story dependencies from the stories generated above. -->

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

## Notes

- [Story] label maps each task to a specific user story for traceability
- Each user story SHOULD be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate the story independently
- Avoid vague tasks and cross-story dependencies that break independence
