---
name: rarebox-release-review
description: Rarebox pre-release review workflow for harness gates, PR checklist, privacy, docs, and launch safety.
tags: [rarebox, release, review, ci]
---

# Rarebox Release Review

Use before merging/releasing meaningful Rarebox changes.

## Checklist

1. Run:
   - `npm run eval:harness`
   - `npm run eval:danger`
   - `npm run build`
   - `npm run smoke:browser`
2. Check danger-zone output and explicitly review any listed file.
3. Confirm no user data paths were weakened.
4. Confirm search/browse works before preload completes if touched.
5. Confirm API behavior is cached/batched/fallback-safe if touched.
6. Confirm UI changes follow Tactile and mobile constraints.
7. Confirm docs/templates/skills/evals were updated for durable lessons.
8. For privacy or public copy, audit actual code before making claims.

## Report format

Lead with outcome, then:
- commit SHA / PR
- files changed
- verification output summary
- danger-zone review notes
- caveats/unverified areas
- recommended next step
