---
sidebar_position: 4
title: Display options
---

# Display options

**WooCommerce > MHM Currency > Display Options**

## Switcher appearance

| Setting | What it does | Default |
|---|---|---|
| **Show flag icon** | Shows a country flag next to the currency | On |
| **Show currency name** | Shows the full name (e.g. "US Dollar") | **Off** |
| **Show currency symbol** | Shows the symbol (e.g. "$", "€") | On |
| **Show currency code** | Shows the ISO code (e.g. "USD", "EUR") | On |

The label is built from whichever parts are on, in this order: symbol → code → name. Turning all four off doesn't leave the label empty — the currency code is shown as a fallback.

## Switcher size

| Size | Font size |
|---|---|
| Small | 12px |
| Medium (default) | 14px |
| Large | 16px |

## Product price widget

A strip under the main price on product pages, showing the price converted into several currencies at once.

| Setting | What it does |
|---|---|
| **Enable product price widget** | Turns the widget on or off |
| **Currencies to display** | Pick up to 5 currencies |
| **Show flags in widget** | Shows a flag next to each price |

When enabled, it appears automatically inside the product's price summary — you don't need to add a shortcode for it. It stays hidden if no currency is selected.

**Example:**

```
Product price: $500.00

€459.20 | £395.10 | ¥75,300
```

A preview at the bottom of the tab reflects your current settings; it's a simplified representation and the real appearance depends on your theme.

## Switching without a page reload

When cache compatibility mode is on (the default — see [Advanced settings](/docs/gelismis)) and a visitor picks a different currency on a shop, category, or product page, the page doesn't reload: the plugin writes the cookie, converts the visible prices in place, and refreshes the mini-cart. On the cart page, for a logged-in visitor, or with cache compatibility switched off, the page reloads as before.

The full list of frequently asked questions and known limits is in
[readme.txt](https://github.com/MaxHandMade/mhm-currency-switcher/blob/develop/readme.txt).
