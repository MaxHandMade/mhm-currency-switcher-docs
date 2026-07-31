---
sidebar_position: 9
title: Currency detection
---

# Currency detection

Every price surface on the site — page renders, the cart, the convert endpoint — resolves the visitor's currency through the exact same four-step chain, in this order:

1. **Cookie** — highest priority.
2. **URL parameter** (`?currency=EUR`).
3. **Geolocation** — only when it's turned on under [Advanced settings](/docs/gelismis).
4. **Base currency** — the fallback.

A code found at any step is discarded (and the chain moves on) unless it's either the store's base currency or a currency you've enabled. There's exactly one implementation of this rule, shared by every caller — no page or endpoint has its own copy that could quietly drift from it.

## Cookie

There are **three** separate places this cookie gets written — if a visitor is stuck in the wrong currency, the fix depends on which one is involved:

1. **Switcher selection.** When a visitor picks a currency from the dropdown, the browser (`switcher.js`) writes the cookie itself.
2. **Geolocation, server-side.** `detect_from_geolocation()` queues whatever it finds, and `prime_currency_cookie()` — hooked at `template_redirect`, priority 0 — writes it to the cookie, **unless the current render is one a page cache is about to store.** On a cacheable render (cache compatibility mode on, visitor logged out, shop/category/product page) this write is deliberately skipped: writing it there would bake one visitor's geolocated currency into the cached HTML and hand it to everyone who loads that page afterward.
3. **Geolocation, client-side.** On exactly the cacheable renders where step 2 backs off, the browser calls the [convert endpoint](/docs/rest-api) itself; if the response comes back `detected: true`, `price-converter.js` writes the cookie instead. Steps 2 and 3 are complementary, not overlapping — for any given render, only one of them ever fires.

All three write the same attributes (30 days, `path=/`, `SameSite=Lax`, `Secure` on HTTPS only) — deliberately kept in sync across two separate scripts and the PHP side, because one attribute out of step means a visitor's choice silently stops persisting in one mode but not the others.

| Property | Value |
|---|---|
| Name | `mhmcs_currency` |
| Lifetime | 30 days |
| Path | `/` (site-wide) |
| Secure | Yes, on HTTPS sites |
| SameSite | Lax |
| HttpOnly | No |

## URL parameter

Appending `?currency=EUR` to a link picks a currency for that page view:

```
https://yourstore.com/product-page/?currency=EUR
https://yourstore.com/shop/?currency=USD
```

Handy for campaign links. It's **read-only** for that request — it deliberately writes no cookie, so a visitor's next page load falls back to whatever the cookie (or geolocation) says, not the parameter. If a cookie is already set, the parameter has no effect at all, since the cookie is checked first. Use the switcher itself if you want a choice to stick.

## Geolocation

Runs only when enabled, and only when there's no cookie yet. See [Advanced settings](/docs/gelismis) for the CloudFlare/MaxMind lookup order and what happens when it can't resolve a country.

## Base currency

The fallback when none of the above produced a usable currency — whatever WooCommerce's own base currency is set to.

## One exception: the convert endpoint

Cache compatibility mode's browser-side [`POST /convert`](/docs/rest-api) request runs through this same chain, but with cookie-writing and geolocation both switched off for that one request — the browser owns the cookie in that mode, and a server-side write there would race it.
