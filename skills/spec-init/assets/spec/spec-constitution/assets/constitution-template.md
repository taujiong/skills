# [PROJECT_NAME] Constitution

## Glossary

<!--
Define canonical terms used across all spec artifacts.
This prevents terminology drift between spec.md, plan.md, and tasks.md.
Each term defined here becomes the authoritative label that all downstream artifacts MUST use.

Example:
- **User**: An authenticated human interacting with the system via the UI.
- **Actor**: Any entity (human or service) that triggers a system action.
- **Acceptance Scenario**: A Given/When/Then statement that defines a verifiable outcome.

Remove this comment block and the placeholder row once the table is filled.
If no domain-specific terms are needed, replace the placeholder row with N/A.
-->

| Term     | Definition     |
| -------- | -------------- |
| [TERM_1] | [DEFINITION_1] |

<!-- Add more rows as needed. Remove placeholder rows before saving. -->

## Principles

<!--
Each principle follows this structure:

  ### I. [Principle Name]
  Rationale: one sentence explaining why this principle exists.

  #### [Sub-section Name]
  - Rule MUST/SHOULD ... (use RFC 2119 uppercase keywords)

Add ### III., ### IV., etc. as needed.
Remove any unfilled placeholder principle sections before saving.
See the Example section at the bottom of this file for a complete illustration.
-->

### I. [PRINCIPLE_1_NAME]

Rationale: [PRINCIPLE_1_RATIONALE]

#### [PRINCIPLE_1_SUBSECTION]

- [RULE_MUST_OR_SHOULD]

<!-- Add more rules as needed. Add more subsections (####) per principle as needed. -->

### II. [PRINCIPLE_2_NAME]

Rationale: [PRINCIPLE_2_RATIONALE]

#### [PRINCIPLE_2_SUBSECTION]

- [RULE_MUST_OR_SHOULD]

<!-- Add more rules as needed. Add more subsections (####) per principle as needed. -->

<!-- Add ### III., ### IV., etc. following the same structure as needed. -->

---

<!-- Example — remove this section before saving:
### I. Test-First Development

Rationale: Tests are the primary enforcement mechanism for safe, verifiable change.

#### Test Quality

- Tests MUST be deterministic: same input produces same result every run.
- Tests MUST be isolated: no shared state, order-independent, parallel-safe.
- Tests MUST follow AAA pattern (Arrange, Act, Assert).
- Tests MUST have clear names describing what behavior is tested and under what conditions.

#### Test Coverage

- New features MUST have integration and unit tests covering all acceptance scenarios from the spec.
- Bug fixes MUST include a regression test that fails before the fix and passes after.
- Refactors that change behavior MUST update or add tests; refactors preserving behavior MUST NOT break existing tests.
- Critical paths (authentication, data persistence, payment flows) MUST have 95% line coverage; common paths SHOULD have 80% line coverage.
-->
