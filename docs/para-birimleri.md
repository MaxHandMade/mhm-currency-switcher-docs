---
sidebar_position: 3
title: Managing currencies
---

# Managing currencies

**WooCommerce > MHM Currency > Manage Currencies**

This is where you configure which currencies your store offers.

## The currency table

| Column | What it does |
|---|---|
| **Enabled** | Turns a currency on or off. Disabled currencies don't show in the switcher. |
| **Code** | The ISO 4217 code, flag, and full currency name. |
| **Rate** | Rate type (Auto / Manual) and the rate value. |
| **Fee** | An extra fee on top of the rate (None / Percent / Fixed). |
| **Rounding** | The rounding rule applied to the converted amount. |
| **Order** | Up/down arrows to reorder the switcher's dropdown. |
| **Actions** | Remove the currency from the list. |

The base currency always sits at the top of the list.

## Add a currency

1. Click **+ New Currency**.
2. Pick a currency from the dropdown (the base currency and ones you've already added are excluded).
3. Click **Add**.
4. Set its rate, fee and rounding.
5. Click **Save Changes**.

A newly added currency starts with: enabled, rate type **Auto**, fee **None**, rounding **None**.

## Rate types

- **Auto** — the rate field is read-only; its value comes from a sync.
- **Manual** — you type the rate yourself, up to 6 decimal places.

Syncing updates every currency's rate regardless of its type, so a manually entered rate can be overwritten by the next sync — check it afterwards if that matters to you.

## Fees

Three ways to add a markup on top of the exchange rate:

| Type | Effect | Example (rate 0.92) |
|---|---|---|
| **None** | No fee | Effective rate 0.92 |
| **Percent** | The rate is increased by a percentage | 2.5% → 0.92 × 1.025 = 0.943 |
| **Fixed** | A flat amount is added to the rate | 0.03 → 0.92 + 0.03 = 0.95 |

## Rounding

Rounding runs **after** the rate and fee are applied, and it isn't limited to product prices — since 1.1.0 it also rounds shipping, fees and coupon discounts the same way.

| Type | Effect |
|---|---|
| **None** | No rounding |
| **Nearest** | Rounds to the nearest multiple of the step |
| **Round up** | Rounds up to the next multiple of the step |
| **Round down** | Rounds down to the previous multiple of the step |

Choosing anything but **None** opens two extra fields:

- **Step** — what to round to (e.g. `1`, `5`, `0.5`)
- **Subtract** — an amount deducted after rounding, useful for charm pricing

**Example:** a converted price of 47.30, Round up, step 1, subtract 0.01 → **47.99**.

A step of `0` disables rounding.

## Syncing rates

**Sync Rates** fetches current rates immediately and writes them into the table. It needs outbound HTTP access from your server — it doesn't work offline.

Rates come from:

1. **ExchangeRate-API** (primary) — `api.exchangerate-api.com`
2. **Fawaz Ahmed Currency API** (fallback) — used if the primary source doesn't respond

Both are free and need no API key. Fetched rates are cached for 1 day; syncing again within that window returns the cached value.

If you have server access, you can sync rates or flush the cache from the command line instead — see [WP-CLI Commands](/docs/wp-cli).

The full list of frequently asked questions and known limits is in
[readme.txt](https://wordpress.org/plugins/mhm-currency-switcher/).
