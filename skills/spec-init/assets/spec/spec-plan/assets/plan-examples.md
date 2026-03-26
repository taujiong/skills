# Plan Template Examples

This file provides format examples for each section of plan-template.md. The `/spec-plan` skill SHOULD reference these examples when generating plan content, but MUST NOT copy them verbatim into the output.

## Technical Context Examples

### Project Setup Format (New Projects)

```markdown
**Language/Toolset**: Python, Bun
**Primary Dependencies**:

- Python
  - FastAPI
- Bun
  - Elysia
  - Zod

**Storage**:

- Database
  - Redis
  - PostgreSQL
- File
  - S3

**Testing**:

- Vitest
- Playwright

**Target Platform**: N/A
**Project Type**: single / web / mobile
**Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]
**Constraints**: [domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]
**Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]
```

### Feature Format (Incremental Changes to Existing Project)

```markdown
**New Dependencies**:

- react-query
  **Testing**:
- Unit test for xxx
- Integration test for xxx
- E2E test for xxx
```

### No New Context

```markdown
No new technical context needed
```

## Core Changes Examples

```markdown
- Introduce a service layer between route handlers and data access — keeps business logic testable in isolation without spinning up HTTP infrastructure.
- Use optimistic locking on the `Order` entity — prevents silent data loss under concurrent updates without the overhead of pessimistic locks.
- Co-locate feature modules (handler + service + model) rather than splitting by layer — reduces cross-directory jumps for a feature-centric team workflow.
```

## Constitution Check Example

```markdown
### Test-First Development

- [ ] Failing tests are defined BEFORE implementation begins
- [ ] All acceptance scenarios from spec have corresponding test cases
- [ ] Bug fixes (if any) include regression tests
- [ ] Integration tests are planned for cross-module behavior
- [ ] All defined tests pass after implementation completes
```

## File Modifications Example

```markdown
root
├── src
│ ├── models
│ │ └── album.ts (Add)
│ ├── services
│ │ └── album.ts (Add)
│ │ ├── add `createAlbum` endpoint
│ │ └── ...
│ └── utils
│ └── date.ts (Modify)
│ ├── add `parse` function
│ └── refactor `compare` function
└── tests
├── models
│ └── album.ts (Add)
├── services
│ └── album.ts (Add)
└── utils
└── date.ts (Modify)
├── add test for `parse` function
└── add test for `compare` function
```

## Dependencies Example

```markdown
- `src/services/album.ts` depends on `src/utils/date.ts` to import `parse` function
```

## Data Models Example

```markdown
1. Album
   - [Add] id (string): unique identifier
   - [Add] name (string): common name
   - [Delete] xxx
   - [Refactor] updatedAt (string → timestamp): for more accurate temporal data
```
