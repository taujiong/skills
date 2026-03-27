# Plan: [SPEC_NAME]

## Technical Context

<!-- Example (greenfield project):
**Language/Toolset**: Python, Bun
**Primary Dependencies**:
- Python
  - FastAPI
- Bun
  - Elysia
  - Zod
**Storage**:
- Database
  - PostgreSQL
- File
  - S3
**Testing**:
- Vitest
- Playwright
**Target Platform**: web
**Performance Goals**: 1000 req/s
**Constraints**: <200ms p95
**Scale/Scope**: 10k users
-->

<!-- Example (incremental feature):
**New Dependencies**:
- react-query
**Testing**:
- Unit test for [SERVICE_NAME]
- Integration test for [ENDPOINT_NAME]
-->

## Core Changes

<!-- Example:
- Introduce a service layer between route handlers and data access — keeps business logic testable in isolation without spinning up HTTP infrastructure.
- Use optimistic locking on the `Order` entity — prevents silent data loss under concurrent updates without the overhead of pessimistic locks.
- Co-locate feature modules (handler + service + model) rather than splitting by layer — reduces cross-directory jumps for a feature-centric team workflow.
-->

## Constitution Check

<!-- constitution:begin -->
<!-- constitution:end -->

## File Modifications

<!-- Example:
root
├── src
│   ├── models
│   │   └── album.ts (Add)
│   ├── services
│   │   └── album.ts (Add)
│   │   ├── add `createAlbum` function
│   │   └── add `deleteAlbum` function
│   └── utils
│       └── date.ts (Modify)
│           └── add `parse` function
└── tests
    ├── models
    │   └── album.ts (Add)
    └── services
        └── album.ts (Add)
-->

## Dependencies

<!-- Example:
- `src/services/album.ts` depends on `src/utils/date.ts` to import `parse`
- `src/routes/album.ts` depends on `src/services/album.ts` to import `createAlbum`
-->

## Data Models

<!-- Example:
1. Album
   - [Add] id (string): unique identifier
   - [Add] name (string): display name
   - [Delete] legacyCode
   - [Modify] updatedAt (string → timestamp): more accurate temporal precision
   - [Constraint] name: required, max 255 chars
   - [Relation] artistId → Artist.id (many-to-one)

2. Order (state transitions)
   - [State] pending → confirmed → shipped → delivered
   - [State] pending → cancelled
-->
