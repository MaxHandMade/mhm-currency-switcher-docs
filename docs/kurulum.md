---
sidebar_position: 2
title: Installation
---

# Installation and requirements

## Requirements

| Requirement | Minimum version |
|---|---|
| WordPress | 6.6 |
| PHP | 7.4 |
| WooCommerce | 7.4 |

This is the only page on this site that states these floors — see them here, not elsewhere.

## Install the plugin

1. Upload the `mhm-currency-switcher` folder to `/wp-content/plugins/`, or install it directly from the WordPress plugin screen.
2. Activate it from the **Plugins** menu.
3. Make sure WooCommerce is installed and active — the plugin does nothing without it, and shows an admin notice saying so.
4. Go to **WooCommerce > MHM Currency**.

You need the `manage_woocommerce` capability to see the settings screen (the Shop manager and Administrator roles have it by default).

## What you get right after activation

- **The currency list starts empty.** No currencies are pre-added; you add the ones you want.
- Geolocation detection starts **on**.
- The switcher's appearance starts with these defaults: flag **on**, symbol **on**, code **on**, currency name **off**, size **Medium**.
- Cache compatibility mode starts **on** — see [Advanced settings](/docs/gelismis) for what that does.

Your store's base currency always comes from WooCommerce's own settings (**WooCommerce > Settings > General > Currency options**). You cannot add the base currency to the plugin's currency list — it is already the conversion's starting point.

## The four settings tabs

| Tab | What it holds |
|---|---|
| **Manage Currencies** | The currency list: rate, fee, rounding, ordering |
| **Display Options** | The switcher's appearance and the product price widget |
| **Advanced** | Geolocation, the automatic rate-update schedule, and cache compatibility |
| **How to use** | Copyable snippets for every place the switcher can be placed on your site |

Unsaved changes show a bar at the top of the screen. **Save Changes** appears both in that bar and at the bottom of the page, and saves all four tabs in one request.

The full list of frequently asked questions and known limits is in
[readme.txt](https://wordpress.org/plugins/mhm-currency-switcher/).
