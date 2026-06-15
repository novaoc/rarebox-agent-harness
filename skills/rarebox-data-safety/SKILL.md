---
name: rarebox-data-safety
description: Rarebox user-data safety workflow for IndexedDB, Pinia, backups, imports, snapshots, QR/local transfer, and destructive changes.
tags: [rarebox, data-safety, indexeddb, backup, import]
---

# Rarebox Data Safety

Use this skill whenever touching `src/stores/portfolio.js`, `src/db.js`, `src/utils/backup.js`, `src/utils/collectrImport.js`, QR/local transfer, snapshots, reset/delete flows, or any bulk data mutation.

## Rules

1. Treat existing shelf data as sacred. Compatibility beats elegance.
2. Never assign Pinia state from outside the store for bulk changes. Add a store action that mutates internal refs and persists.
3. Backup/import inputs are hostile. Strip `__proto__`, `constructor`, and `prototype`; clamp sizes/counts/strings before deep parsing where possible.
4. Preserve zero values. `$0`, `0`, and snapshot value `0` are valid data, not missing data.
5. Restore only namespaced localStorage keys. Never import arbitrary keys from a backup.
6. If import/restore/delete changes, add or update `scripts/evals/backup-roundtrip.mjs`.

## Required verification

- `npm run eval:harness`
- `npm run eval:danger`
- `npm run build`
- `npm run smoke:browser` if Settings/import/export UI changed

## Report

Explicitly state whether backup/import compatibility, snapshots, and existing shelf data were affected.
