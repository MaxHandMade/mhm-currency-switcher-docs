---
sidebar_position: 12
title: REST API reference
---

# REST API reference

**Namespace:** `mhmcs/v1` · **Base URL:** `/wp-json/mhmcs/v1/`

Most sites never call these directly — the switcher, the product widget, and cache compatibility mode all use them automatically. They're here for anyone building an integration or debugging a caching setup.

## Public endpoints

### GET `/rates`

*Removed in 2.1.0. On 2.0.0, `/mhmcs/v1/rates` works as described below;
from 2.1.0 use the conversion endpoint instead.*

No authentication needed. Returns the base currency and the effective (fee-included) rate for each enabled currency.

```bash
curl https://yourstore.com/wp-json/mhmcs/v1/rates
```

```json
{
    "base": "TRY",
    "rates": {
        "EUR": 0.0274,
        "USD": 0.0293,
        "GBP": 0.0250
    }
}
```

### POST `/convert`

*Since 1.1.0.* This is what the browser calls, automatically, when [cache compatibility mode](/docs/gelismis) is on — it asks for the real prices of whatever products are marked on an otherwise base-currency-cached page. Send `product_ids` (up to 50 per request; the server enforces the cap regardless of what you send) and, optionally, a `currency`; omit it to let the server [detect](/docs/algilama) the visitor's currency for you. The response echoes back which currency was used and the priced HTML for each ID:

```json
{
    "currency": "EUR",
    "detected": false,
    "prices": { "101": "<span class=\"woocommerce-Price-amount amount\">€13,68</span>" }
}
```

`detected` is `true` only when the server itself resolved the currency (geolocation succeeded, with no `currency` sent in the request) — it's `false` for an explicit `currency`, and `false` when detection came up empty too. It matters because the browser's own cookie write is gated on it: `price-converter.js` only persists the cookie when `detected: true`, so a failed detection isn't pinned to the base currency and geolocation gets retried on the visitor's next page.

It's unauthenticated by design — the pages it serves are read by logged-out visitors with no nonce to send — but tightly scoped: only already-public product HTML, nothing written server-side, and a per-address rate limit of **120 requests a minute**, adjustable via the `mhmcs_convert_rate_limit` filter. Going over it returns `429` with a `Retry-After` header. For the full write-up of why it's shaped this way, see the ["Is there a limit on how often the conversion endpoint can be called?"](https://github.com/MaxHandMade/mhm-currency-switcher/blob/develop/readme.txt) entry in readme.txt.

## Admin endpoints

> All of these require the `manage_woocommerce` capability. The settings screen itself is a client of these same routes.

| Method | Endpoint | What it does |
|---|---|---|
| GET | `/settings` | Fetch plugin settings |
| POST | `/settings` | Save plugin settings |
| GET | `/currencies` | Fetch the base currency and configured currencies |
| POST | `/currencies` | Save currencies |
| POST | `/rates/sync` | Fetch and update rates from source |
| GET | `/rates/preview` | Raw and effective rate per currency |

## Currency on the WooCommerce product API

Add a `currency` parameter to WooCommerce's own product endpoints to get converted prices back:

```bash
curl https://yourstore.com/wp-json/wc/v3/products?currency=EUR
```

`price`, `regular_price`, and `sale_price` come back converted, and a `currency_code` field is added. Omit the parameter, or send one your store doesn't offer, and the response is pinned to your base currency — so the answer depends only on the request, never on the caller's cookies.

The full list of frequently asked questions and known limits is in
[readme.txt](https://github.com/MaxHandMade/mhm-currency-switcher/blob/develop/readme.txt).
