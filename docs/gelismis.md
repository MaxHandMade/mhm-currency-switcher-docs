---
sidebar_position: 5
title: Advanced settings
---

# Advanced settings

**WooCommerce > MHM Currency > Advanced**

This tab holds four settings.

## Geolocation detection

| Setting | What it does |
|---|---|
| **Enable geolocation-based currency detection** | Detects the visitor's country and shows the matching currency |

Country detection tries two sources, in order:

1. **CloudFlare (primary)** — if your site is behind CloudFlare, the country code is read from the `CF-IPCountry` header. No configuration needed, and fast. Unknown-country and Tor exit-node codes are ignored.
2. **WooCommerce MaxMind (fallback)** — if there's no CloudFlare header, WooCommerce's built-in MaxMind GeoIP database is queried instead. This needs a license key entered under **WooCommerce > Settings > Integration > MaxMind Geolocation**.

**How it works:**

1. Detection runs only when the visitor has no currency cookie yet.
2. The country code maps to a currency.
3. If that currency isn't **enabled** in your store, detection is treated as a miss and the base currency is used.
4. On a successful detection, a cookie is written so detection doesn't run again on later pages.
5. If the visitor picks a different currency from the switcher, that choice is saved to the cookie and takes priority over geolocation from then on.

## Automatic rate updates

Rates can update automatically via WordPress's scheduled-task system (WP-Cron).

| Option | Effect |
|---|---|
| **Manual only** | No automatic updates; the scheduled task is removed |
| **Hourly** | Updates once an hour |
| **Twice daily** | Updates twice a day |
| **Daily** | Updates once a day |

Changing the interval clears the existing scheduled task and reschedules it. Deactivating the plugin removes the task entirely.

WP-Cron isn't a real system cron — it only fires on incoming traffic. On a low-traffic site, point your server's crontab at `wp-cron.php` so updates keep running on schedule.

Rate sources need no API key, so this tab has no provider selector or key field.

## Cache compatibility mode

*Since 1.1.0.*

A page cache stores the HTML your server produced for whoever asked first. When prices are converted on the server, that means the first visitor's currency is what every later visitor is served.

**Cache compatibility mode**, on by default, avoids this: for logged-out visitors, shop, category and product pages are always rendered in your **base currency**, so the same cached page is correct for everyone. The browser then converts the displayed prices, after the page loads, through a request to this plugin.

The split is deliberate: only *displayed* prices are converted in the browser. Cart, checkout, order totals, order emails and the WooCommerce REST API are always calculated on the server, in the currency the customer actually chose — so the amount charged can't be altered from the browser.

| Setting | What it does |
|---|---|
| **Cache pages in the base currency** | Turning this off converts prices on the server again, as before 1.1.0 — which doesn't play well with a page-caching plugin. Cart, checkout and order totals are always converted on the server either way. |

Turning the mode off doesn't restore 1.0.0 behaviour exactly — the admin, REST API and scheduled-task fixes stay active in both modes.

## What happens when the plugin is removed

*Since 1.3.0.*

| Setting | What it does |
|---|---|
| **Delete all data when the plugin is removed** | Off by default. Left off, your settings and the currency and exchange rate recorded on each order stay in place when the plugin is deleted. |

Those per-order records are the only basis for multi-currency sales history and cannot be
rebuilt afterwards, which is why the destructive choice is the one you have to make
deliberately rather than the one that happens by default. Deactivating the plugin never deletes
anything; only deleting it does, and only with this switch on.

On a multisite network the switch clears the site the plugin is removed from.

The full list of frequently asked questions and known limits is in
[readme.txt](https://github.com/MaxHandMade/mhm-currency-switcher/blob/develop/readme.txt).
