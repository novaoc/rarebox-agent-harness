---
name: rarebox-task-runner
description: Repeatable Rarebox agent task workflow using spec templates, narrow implementation, harness checks, and structured reporting.
tags: [rarebox, agentic-engineering, specs, workflow]
---

# Rarebox Task Runner

Use this for well-defined Rarebox implementation tasks.

## Loop

1. Pick the right template from `docs/harness/templates/`:
   - feature-spec.md
   - bugfix-spec.md
   - provider-integration-spec.md
   - review-checklist.md
2. Fill the minimum needed spec: goal, non-goals, affected files, acceptance criteria, verification.
3. Inspect files and trace symbols before editing.
4. Make the smallest reversible change.
5. Add/update harness coverage when a durable invariant is involved.
6. Run verification:
   - `npm run eval:harness`
   - `npm run eval:danger`
   - `npm run build`
   - `npm run smoke:browser` when UI/routes/app shell changed
7. Report verified facts, assumptions, and gaps.

## Anti-patterns

- Starting with implementation before acceptance criteria on risky work.
- Removing features because a generated patch made it convenient.
- Treating build success as enough for user-data/search/API changes.
- Hiding blocked verification.
