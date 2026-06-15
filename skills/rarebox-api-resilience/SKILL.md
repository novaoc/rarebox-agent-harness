---
name: rarebox-api-resilience
description: Rarebox API resilience workflow for provider integrations, search, pricing, preload, caching, and fallback paths.
tags: [rarebox, api, search, pricing, providers]
---

# Rarebox API Resilience

Use when touching provider/search/preload/pricing code, especially `src/services/tcg/providers.js`, `multiSearch.js`, `cardCache.js`, `cardPreloader.js`, price services, or serverless scrapers.

## Product invariant

Rarebox must be usable from first render. Never block search or browse behind background card loading. Cache-first is good; cache-only misses must fall through to live APIs unless the UX is explicitly offline-only.

## Rules

1. Cache repeated requests with documented TTL.
2. Bound concurrency to avoid looking like scraping.
3. Use timeouts and retry transient 429/5xx/network failures.
4. Return stale/local data when live APIs fail.
5. Preserve provider quirks in tests/docs/skills.
6. Price parsers must treat `0` as valid.
7. Variant prices must not inherit base prices when that would be wrong.

## Required coverage

- Provider registry/shape: `scripts/evals/provider-shape.mjs`
- Variant/price normalization: `scripts/evals/provider-normalization.mjs`
- Search fallback: `scripts/evals/search-fallback.mjs`
- Sealed filtering: `scripts/evals/sealed-filter.mjs`
- Zero prices: `scripts/evals/price-parser.mjs`

## Verification

- `npm run eval:harness`
- `npm run eval:danger`
- `npm run build`
- `npm run smoke:browser` if routes/app shell changed
