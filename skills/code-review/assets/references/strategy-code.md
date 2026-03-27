# Review Strategy: Source Code

> **Priority note**: If `specs/constitution.md` is present in the project, its principles take precedence over any rule in this document. Where there is a conflict, follow `specs/constitution.md`. The dimensions below apply as defaults when `specs/constitution.md` does not address a particular concern.

---

## Dimensions

### 1. Code Quality

Check each of the following:

- **Naming**: Variables, functions, and files use clear, intention-revealing names. Abbreviations are avoided unless universally understood. Boolean names are affirmative (`isLoading`, not `notReady`).
- **Comments**: Comments explain _why_, not _what_. No commented-out dead code. No misleading or stale comments that contradict the implementation.
- **Clean Architecture**: No cross-layer imports (e.g. domain logic importing from infrastructure). Business logic is not mixed with I/O, framework code, or presentation concerns.
- **Duplication**: Repeated logic is extracted. DRY violations are flagged unless the duplication is genuinely coincidental similarity rather than shared abstraction.
- **Cyclomatic Complexity**: Functions with deeply nested conditionals or many branches are candidates for decomposition.

### 2. Single Responsibility

- Identify functions, modules, or files that do more than one thing.
- Flag units that mix abstraction levels (e.g. orchestration logic alongside low-level I/O in the same function).
- Suggest extraction points with concrete names (e.g. "extract `validateInput()` from `processOrder()`").

### 3. Performance

- **Algorithmic complexity**: Flag O(n²) or worse patterns where a better algorithm exists.
- **N+1 queries**: Database or API calls inside loops.
- **Redundant computation**: Values that are recomputed on every call but could be memoized or cached.
- **Blocking I/O**: Synchronous file or network operations inside async contexts.
- **Memory**: Large allocations inside hot paths; missing cleanup of resources (connections, handles, subscriptions).

### 4. Security

- **Injection**: SQL, shell command, XSS, path traversal, template injection.
- **Credentials**: Hardcoded secrets, tokens, or passwords; `.env` values logged or returned in responses.
- **Input validation**: Untrusted input used without sanitization or schema validation.
- **Access control**: Missing authorization checks; privilege escalation paths.
- **Dependencies**: Newly added packages — note any with known CVEs or suspicious provenance.
- **Unsafe operations**: Deserializing untrusted data; `eval`-like constructs; unsafe type casts.

### 5. Documentation Completeness

- Every exported/public function, class, and type should have a doc comment (JSDoc, docstring, etc.).
- New modules should have a brief header comment explaining their purpose and responsibilities.
- If the change alters existing behavior, check whether the corresponding doc comment is updated.
- If a new entry point is added (CLI command, API route, public module), check whether a README or usage note is needed.

### 6. Testability Signal (advisory)

- Flag logic that is difficult to test in isolation (e.g. untestable side effects mixed into business logic, lack of dependency injection).
- Do not require tests to exist, but note when the design makes testing unnecessarily hard.

---

## Severity Guidance for Source Code

| Finding                                                                 | Typical Severity |
| ----------------------------------------------------------------------- | ---------------- |
| Security vulnerability (injection, secrets)                             | P0               |
| Incorrect logic / data corruption risk                                  | P0               |
| Design principle violation causing high coupling or hidden dependencies | P1               |
| Unit doing too many things / missing decomposition                      | P1               |
| Performance regression (N+1, blocking I/O)                              | P1               |
| Missing doc on public API                                               | P2               |
| Naming / comment issue                                                  | P2               |
| Style / micro-optimization                                              | P3               |
