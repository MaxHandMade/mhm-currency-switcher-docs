---
sidebar_position: 10
title: Currency conversion
---

# Currency conversion

## The formula

```
Converted price = Base price × Effective rate   → rounding (if set)
```

The effective rate folds in whatever fee type a currency has:

| Fee type | Formula |
|---|---|
| None | Effective rate = Raw rate |
| Percent | Effective rate = Raw rate × (1 + Fee / 100) |
| Fixed | Effective rate = Raw rate + Fixed fee |

**Example** — base currency TRY, product price 500:

| Currency | Raw rate | Fee | Effective rate | Converted price |
|---|---|---|---|---|
| EUR | 0.0267 | 2.5% | 0.0274 | €13.68 |
| USD | 0.0293 | None | 0.0293 | $14.65 |
| GBP | 0.0230 | 0.002 fixed | 0.0250 | £12.50 |

If a currency's rate is 0, or the currency can't be found, the price is left unconverted rather than shown as zero.

Rounding (Nearest / Round up / Round down, by a step and an optional subtract amount — see [Managing currencies](/docs/para-birimleri)) runs **after** the rate and fee. It's not limited to product prices — since 1.1.0 it also applies to shipping and cart fees, and to fixed-amount coupons.

## What gets converted

| Field | Behaviour |
|---|---|
| Product price (regular and sale) | Converted, rounded |
| Variation prices and price ranges | Converted, rounded |
| Cart and order totals | Computed from the already-converted line items |
| Cart fees | Converted, rounded |
| Shipping cost | Converted, rounded |
| Shipping tax | Converted, **not rounded** — it travels with the shipping cost |
| Fixed-amount coupons | Converted, rounded |
| Coupon minimum/maximum spend | Converted, **not rounded** |

Percentage-based coupons are left alone — a 10% discount is 10% regardless of currency.

The two "not rounded" rows are deliberate, not oversights: neither a shipping tax line nor a coupon spend threshold is an amount the customer pays directly, so rounding either would edit a rule (a tax calculation, a merchant-set threshold) rather than tidy a price on screen.

## Orders

The currency, rate, and base currency active at checkout are stored on the order. Order admin screens and order emails always show the amount the customer actually paid, in the currency they paid it in — and orders placed before you installed the plugin, or before a given price change, are never rewritten retroactively.
