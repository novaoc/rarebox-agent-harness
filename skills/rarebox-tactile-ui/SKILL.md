---
name: rarebox-tactile-ui
description: Rarebox Tactile UI workflow for visual changes, responsive behavior, copy, and browser smoke checks.
tags: [rarebox, ui, tactile, mobile]
---

# Rarebox Tactile UI

Use for any visible UI, copy, route, layout, modal, or mobile change.

## Tactile rules

- Use tokens from `src/assets/main.css`; avoid hardcoded component colors.
- Cream paper, white cards, near-black ink.
- 2px ink borders, hard offset shadows; no blurred shadows/glass/glows.
- Pressed controls compress shadow and translate by 1px.
- Touch targets should be around 44px or larger.
- Mobile must work down to 280px without horizontal overflow.
- Copy says “shelves”, not “portfolios”, unless it is internal code naming.
- Respect `:focus-visible` and `prefers-reduced-motion`.

## Verification

- `npm run build`
- `npm run smoke:browser`
- Use the smoke output to confirm routes render on desktop and 280px mobile.
- For visual changes, report tested routes and viewport assumptions.
