---
name: rarebox-provider-integration
description: Add, repair, or review Rarebox TCG provider/search/price integrations safely.
tags: [rarebox, tcg, providers, search, prices, vue]
---

# Rarebox Provider Integration

Use this skill when adding, fixing, reviewing, or auditing TCG integrations in Rarebox: browse providers, multi-search, card preload, price feeds, sealed/graded pricing, and provider registry drift.

## Load-Bearing Product Rules

- Rarebox must stay usable from first render. Never block search behind preload.
- Cache-first is good; cache-only is unacceptable unless the user explicitly asked for offline-only behavior.
- Public APIs must be respected: batching, caching, timeouts, retries, and graceful stale-data fallback.
- User collection data safety outranks clever architecture.
- User-facing copy says shelves, not portfolios. Code may keep legacy `portfolio` identifiers.
- Tactile design rules apply to any UI: tokens, hard ink shadows, press feedback, no glows/glass.

## Files to Inspect First

Always inspect the current code before editing; do not rely on memory.

- `src/services/tcg/providers.js` — browse provider registry and TCG landing metadata.
- `src/services/tcg/multiSearch.js` — search provider registry, cache/live fallback, sealed search.
- `src/services/tcg/cardCache.js` — IndexedDB + in-memory search index.
- `src/services/tcg/cardPreloader.js` — background card preload and progress.
- `src/stores/portfolio.js` — item model, price refresh routing, persistence.
- `src/db.js` — Dexie schema, staleness helpers.
- `src/components/AddItemModal.vue` — add card/graded/sealed UX.
- `src/views/TcgSetsView.vue`, `src/views/BrowseView.vue`, `src/views/SearchView.vue` — UI integration.
- `src/router/index.js` — route ordering; `/sets/pokemon` must outrank `/sets/:game`.
- `scripts/evals/` — harness evals that must pass after integration work.

## Provider Contract

Browse providers normalize APIs into:

```js
Set:  { id, name, code, releaseDate, total, logo }
Card: { id, name, number, image, price, rarity }
```

Search normalizes cards into:

```js
{ id, name, number, set, image, price, rarity, game }
```

When adding a TCG, update every relevant registry:

1. `src/services/tcg/providers.js`
   - provider object with `id`, `getSets()`, `getSetCards(setId)`
   - `PROVIDERS` map
   - `TCGS` entry with route `/sets/<game-id>` and inline SVG logo
2. `src/services/tcg/multiSearch.js`
   - search function
   - `ALL_PROVIDERS` map
   - resolve function if decks/price refresh need card-by-ID lookup
3. `src/services/tcg/cardPreloader.js`
   - preload strategy if offline/local search should support the game
4. UI filters/badges if the game should be selectable in search/add flows
5. `scripts/evals/` if the contract expands

## API Evaluation Checklist

Before choosing or changing an API, verify the load-bearing claims yourself:

- CORS from browser context or curl preflight.
- Response shape on real sample queries.
- Pagination limits and max page size.
- Image URL stability.
- Price semantics: market vs low listing vs stale fallback.
- Rate limit posture.
- Payload size and expected local storage cost.
- Whether `$0` is a valid price. It usually is; do not parse it as null.

Record rejected options and why when the choice is consequential.

## Price Rules

- Parse `"$1,234.56"` by stripping `$` and commas.
- Preserve `$0` / `0` as a valid numeric price. Use `n >= 0`, not `n > 0`, in parsers.
- Use `null` for missing/invalid prices.
- Variant printings must not inherit plain-card prices when that would be misleading.
- Sealed product search must filter individual cards (`#123`, set-number codes, `12/204`) and accessories.
- For sealed refresh, include set name in the query to avoid generic popular product mismatches.

## Known Provider Pitfalls

- Pokémon: use `select=` to reduce payloads; resolve cards by set code + number when importing/meta decks.
- Japanese Pokémon: preserve `_lang` top-level and in `cardData`; tcgdex/Pokellector paths are easy to break.
- MTG: Scryfall sets/cards paginate; bulk data can be huge depending on endpoint.
- Yu-Gi-Oh: YGOPRODeck `cardset=` matters; set-specific prices can differ from card-level cheapest-printing price.
- Lorcana: Lorcast shapes may return arrays or `results` depending on endpoint.
- One Piece: optcgapi often returns all cards in one call; cache and search client-side.
- Riftbound: riftcodex has card data, but price hydration is variant-sensitive.
- PriceCharting: CORS JSON endpoints and feeds are useful, but fuzzy search can return wrong products; filter aggressively.
- Limitless: scraper is fragile; cache and keep fallback behavior.

## Verification

After provider/search/price changes, run:

```bash
npm run eval:harness
npm run build
```

If the change affects a live API, also run a narrow manual/browser smoke check against the real flow, while watching for unexpected request bursts.

## Review Questions

Before reporting done:

- Is every registered TCG present in browse and search registries?
- Does search still work before preload finishes?
- Did any parser collapse zero prices to null?
- Are API calls bounded, cached, timed out, and resilient?
- Did UI changes follow Tactile and mobile rules?
- Did import/export or persisted data shapes change? If yes, what migration/compatibility path protects existing users?
- What exactly was verified, and what remains unverified?
