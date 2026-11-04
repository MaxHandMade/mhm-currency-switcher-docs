---
slug: currency-switcher-v2.3.0-release
title: "Currency Switcher 2.3.0 — a keyboard-friendly switcher, and converted prices that follow the real one"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-04T02:30
---

2.3.0 makes the currency switcher usable from the keyboard, hides the converted prices whenever a product's own price is hidden, and loads less on pages that don't need the switcher. It also raises the WooCommerce minimum to 9.1, so check your WooCommerce version before you update.

{/* truncate */}

## WooCommerce 9.1 or later

The plugin used to say it supported WooCommerce 7.4, but nothing tested that. The minimum now names the oldest WooCommerce the plugin's automated tests actually install: **9.1**. If your shop runs WooCommerce 7.4–9.0, update WooCommerce first. The full list of requirements is on the [installation page](/docs/installation).

## The switcher works from the keyboard

You could reach the switcher with Tab and open it with Enter, but no key could pick a currency. Now **Enter**, **Space** or an **arrow key** open the list on the current currency. **↑ ↓ Home End** move through it, **Enter** or **Space** picks a currency, and **Escape** closes the list without changing anything. Keyboard focus is outlined, including when the switcher sits in a navigation menu, where it used to be invisible. This works the same in the shortcode, the Elementor widget and the menu item. See [Display options](/docs/display-options).

## Converted prices are hidden when the price is

If a theme or plugin hid a product's price (a catalogue or maintenance mode, "log in to see prices"), WooCommerce's price disappeared but the converted prices stayed printed under it. The product price widget now follows the product's own price. When the price is hidden or replaced by a message, the converted prices go too. When a plugin only adds to the price, such as a "VAT included" note, they stay.

## Less to load where the switcher isn't used

When prices are converted on your server (cache compatibility off, logged-in customers, the cart and checkout), the switcher's script now loads only on pages that show a switcher. With cache compatibility on, which is the default, nothing changes.
