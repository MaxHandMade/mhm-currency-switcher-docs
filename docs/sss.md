---
sidebar_position: 13
title: FAQ
slug: /faq
---

# FAQ

This page merges the plugin's readme.txt FAQ with a handful of questions specific to this guide's readers. Where a question appears in both places, the readme's answer is used here — readme.txt is the source of record.

### How many currencies can I add?

As many as your shop needs — every currency WooCommerce offers can be enabled, and nothing is held back for a paid version. The REST API refuses a request carrying more than 500 currency rows; that is a guard against oversized payloads and is well above the number of codes WooCommerce itself offers, so the panel cannot reach it. The one place a cap is user-visible is the product price widget: the **Display Options** tab lets you show at most 5 currencies there at once.

### How are exchange rates fetched?

Exchange rates are fetched from ExchangeRate-API in real time, either on demand or on a schedule you configure (hourly, twice daily, daily, or manual only) so your rates stay current without manual intervention.

If that source cannot be reached, the plugin tries one fallback — the European Central Bank's daily reference feed — before giving up and leaving your existing rates in place. Both are named, with their terms, on the [Managing currencies](/docs/managing-currencies) page. If your network blocks the fallback, the `mhmcs_fallback_rates_url` filter can point it somewhere else; since 2.1.0 the filter's source argument is always `ecb`, because the chain has a single fallback.

Fetched rates are cached for 1 day, and that cache only backs the price display shoppers see — a sync always skips it and goes straight to the source, whether you press **Sync Rates**, run the WP-CLI command, or let the scheduled task fire.

### What are the shortcodes?

`[mhmcs_currency_switcher]` renders the currency dropdown. It accepts one attribute, `size`, which may be `small`, `medium` or `large`; leave it out to use the size saved in Display Options.

`[mhmcs_currency_prices]` renders the same product price in several currencies. Its attributes are all optional:

- `currencies` — comma-separated codes, e.g. `currencies="USD,EUR"`. Without it, the currencies chosen in Display Options are used. Codes you have not configured as currencies are ignored.
- `product_id` — price a specific product instead of the one being viewed.
- `price` — price a specific amount instead of a product's.
- `show_flags` — `true` or `false`, overriding the saved Display Options setting.

Both are also available as Elementor widgets. See [Placing the switcher](/docs/placing-the-switcher) for the shortcodes' rename history and every way to add them to your site.

### Can I set a fixed price for a specific product?

Yes. Use the **Currency Prices** tab on the product edit screen — see [Fixed prices per product](/docs/fixed-prices) for the details. One thing worth knowing: a fixed price is stored per product and currency, not per price type, so the same amount is used for the regular price and the sale price. A product that's on sale in your base currency shows as not on sale in a currency you've given a fixed price to. If you want the sale to carry across, leave that currency to the exchange rate instead of fixing it.

### Is the plugin compatible with WooCommerce HPOS?

Yes. MHM Currency Switcher fully supports WooCommerce High-Performance Order Storage (HPOS / Custom Order Tables).

### What currency are orders recorded in?

Whichever currency the customer was using when they placed the order. The order stores the currency code, the exchange rate that was applied, and your store's base currency at that moment. That record is what lets you export orders and recalculate them correctly with their own rates, even though WooCommerce Analytics adds orders placed in different currencies together into a single, misleading total.

### Does removing a currency delete its data?

No. Taking a currency out of the list only removes it from your configuration. Orders already placed in that currency, and the exchange rate recorded on them, are unaffected.

### Is there a limit on how often the conversion endpoint can be called?

Yes. When cache compatibility mode is on, prices on cached pages are converted through a public REST endpoint, and one address may call it 120 times a minute by default. Ordinary browsing is nowhere near that — a page makes one request. If your shop sits behind a reverse proxy or a CDN that makes every visitor look like the same address, raise or disable the limit with the `mhmcs_convert_rate_limit` filter. Note that the address is read from the proxy headers WooCommerce passes on, which it trusts unconditionally and which can be forged; the limit bounds accidental hammering rather than a determined attacker.

### I see a warning that cache compatibility is not being applied. What is it?

Some themes and plugins define WooCommerce's cart constant on every page, usually to show a cart total in the header. When that happens the plugin treats every page as a checkout — the customer's money is at stake — and converts prices on the server, which is exactly what cache compatibility mode exists to avoid. Nothing looks wrong on the site: prices are still correct for whoever loads the page first, and then a page cache can serve that person's currency to everyone else. Because there is no visible symptom, the plugin says so in the admin instead. The notice clears itself as soon as a front-end page renders normally again.

### Why does the structured data show a different currency from the price on the page?

With cache compatibility on, the page is generated in your base currency and the browser converts the prices afterwards, so the machine-readable product data a crawler reads stays in the base currency. This is deliberate and is not corrected: pinning it the other way would leave the data disagreeing with the page in the one case where the two currently agree — with cache compatibility switched off, where the page and the structured data are both converted on the server.

### Does the WooCommerce REST API return converted prices?

Only when the request asks for a currency: `?currency=EUR` on a `wc/v3` product request converts `price`, `regular_price` and `sale_price` and adds a `currency_code` field. Without the parameter the response is pinned to your base currency, so the answer never depends on the cookies of whoever is calling. A per-product fixed price takes precedence over the exchange rate here, exactly as it does on the shop page.

One known limit: the `price_html` field is not pinned in the same way. It cannot be reached in that state by a normal `wc/v3` client — only by code that dispatches an internal REST request during a page render — so no integration sees it, but it is not consistent with the three numeric fields and is recorded here rather than left unsaid.

### Prices aren't changing — what should I check?

1. Make sure the currency is **Active**.
2. Confirm the rate isn't zero — at a zero rate, prices are left unconverted.
3. Pull a fresh rate with the **Sync Rates** button.
4. Clear your browser cache (Ctrl+Shift+R).
5. If you run a page caching plugin, flush its cache — the selected currency is kept in a cookie, so a cached page can keep showing an old currency.

### What happens to my data if I delete the plugin?

By default, deleting the plugin keeps your settings, currency configuration, and the currency and exchange rate recorded on each order — deletion only clears what should never survive, such as cached rates, scheduled tasks, and secrets stored by settings that have since been removed. To have the plugin remove everything instead, including order currency data (both in classic order meta and in the order tables of stores using HPOS), turn on **Delete all data when the plugin is removed** in [Advanced settings](/docs/advanced-settings) before you delete it. With that switch left off, your multi-currency sales history survives even after the plugin is gone.

Something not answered here? Open an issue on
[GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/issues).
