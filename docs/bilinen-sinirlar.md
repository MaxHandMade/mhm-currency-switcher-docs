---
sidebar_position: 14
title: Known limits
slug: /known-limits
---

# Known limits

These are consequences of how cache compatibility mode works, not defects. They're listed here so you can decide with your eyes open.

### Turning the mode off does not restore the exact 1.0.0 behaviour

Three fixes sit above the setting and stay in place whether it is on or off: prices are no longer converted on admin screens or in admin AJAX (which used to write a converted price into an order line item), `wc/v3` REST reads are pinned to the base currency, and scheduled tasks and WP-CLI no longer convert. Switching the mode off restores the 1.0.0 *display* behaviour — prices converted on the server — and nothing else.

### Search engines and crawlers see your base prices

With the mode on, the page a crawler fetches has not been through the browser, so it carries base-currency prices, and so does the machine-readable product data in it. See the related question in the [FAQ](/docs/faq); the mismatch is deliberate.

### Converted prices replace the base ones a moment after the page appears

The page arrives with your base-currency prices already on screen — nothing is hidden waiting for JavaScript — and the browser swaps in the converted ones as soon as its request comes back, each price fading over 200ms as it changes. On a slow connection the base price is readable for longer before the swap. Visitors who have asked their system for reduced motion get the swap without the fade.

### With JavaScript disabled, or the endpoint unreachable, base prices stay

Nothing breaks and no error is shown to the visitor — the page simply keeps the base-currency prices it was rendered with, and the reason is written to the browser console. Cart and checkout are unaffected, because they never depended on the browser in the first place.

### Variable products make one extra request, and some swatch plugins lose the price

On a cacheable page the plugin forces WooCommerce to fetch variation prices over AJAX, because the variations JSON WooCommerce would otherwise embed in the page carries base-currency prices that its own scripts write straight into the page. The cost is one request when a visitor picks a variation, and that `data-product_variations` is `false`: third-party colour or size swatch plugins that read prices out of that JSON instead of asking WooCommerce may stop showing a price. If you use such a plugin, check a variable product before going live.

### The mini-cart relies on WooCommerce cart fragments

A mini-cart is rendered on every page, so it cannot be classified per request. It is rendered in the base currency and then corrected by WooCommerce's own cart fragment refresh, which is a server-side conversion. If cart fragments are disabled on your site — some themes and optimisation plugins dequeue them — the cached mini-cart total stays in the base currency while the rest of the page converts. The plugin watches for this and says so in the admin when it happens; a site with no mini-cart at all is never warned about it.

### A cart or checkout on a page WooCommerce does not know about must be excluded from your cache

Page caches exclude cart and checkout automatically because they recognise the pages WooCommerce assigned. If you have put a cart or checkout shortcode or block on some other page, exclude that page yourself. Two things go wrong otherwise: the conversion decision flips to "convert" partway through the render, so the rest of the page is printed already converted and without the markers the browser looks for, and blocks-based cart and checkout embed their amounts in the page as JSON while rendering. Either way the first visitor's currency is what the cache then hands to everyone. Cart contents are personal anyway; such a page should not be cached.

### `?currency=` multiplies your cache entries

A currency can be requested in the URL, and a cache treats every distinct URL as a separate entry, so linking to `?currency=EUR` and `?currency=GBP` stores the same page more than once. The switcher itself does not produce these URLs — it writes a cookie and leaves the address alone. On a cached page it converts the prices where they stand; on the cart page, for a logged-in visitor, or with cache compatibility switched off, it reloads instead. Either way the URL is the one the visitor was already on, so no extra cache entry is created.

A `?currency=` link also applies to that page view only: it deliberately sets no cookie, so the next page the visitor opens is back in your base currency unless they use the switcher. That is not an oversight — a link that silently pinned a currency could show one currency in the catalogue while the cart, which reads the cookie, charged another. If you want a campaign link that sticks, send visitors to a page carrying the switcher rather than relying on the parameter.

### WooCommerce Analytics adds different currencies together

An order is stored in the currency the customer paid in, and WooCommerce Analytics reports every order's figures in your store currency without converting them back. A 4.38 USD order is counted as 4.38 in your base currency, so once you take orders in more than one currency the revenue figures in Analytics, and the totals in the customer panel on the order screen, are sums of unlike amounts. The orders themselves are correct — each one keeps its own currency, total and the exchange rate it was placed at, and this plugin stores that rate on the order. It is the aggregate reports that cannot be read as money. Nothing in this plugin can fix that from the outside; if you need accurate multi-currency reporting, export the orders and convert them using the rate recorded on each one.

### Logged-in visitors are converted on the server

Logged-in visitors take the server-side path, which is correct as long as your cache does what nearly all of them do and never serves cached pages to logged-in users. An edge cache or CDN configured to cache without looking at cookies is the exception, and there a logged-in visitor's converted page can be stored and served on. If you cache at the edge, confirm it varies on the login cookie.
