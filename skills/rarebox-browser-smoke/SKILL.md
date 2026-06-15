---
name: rarebox-browser-smoke
description: How to run and interpret Rarebox browser smoke tests.
tags: [rarebox, smoke, puppeteer, ci]
---

# Rarebox Browser Smoke

Rarebox smoke tests live at `scripts/smoke/browser-smoke.mjs` and run with:

```bash
npm run smoke:browser
```

They start `vite preview`, launch Chrome/Chromium via `puppeteer-core`, and verify app-shell rendering.

## What it checks

Desktop routes:
- `/`
- `/search`
- `/sets`
- `/sets/pokemon`
- `/sets/yugioh`
- `/settings`
- `/trade`

Mobile 280px routes:
- `/`
- `/search`
- `/sets`
- `/settings`

Assertions:
- app is not blank
- title includes Rarebox
- route renders text
- no horizontal overflow at the tested viewport

## Important pitfall

Do not wait for network-idle. Rarebox intentionally starts background data work on first render, so network-idle turns healthy background loading into flaky failures. The smoke test waits for `domcontentloaded` plus app text.
