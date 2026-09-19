---
slug: currency-switcher-v2.2.0-release
title: "Currency Switcher 2.2.0 — Visitor IP addresses no longer leave your server"
authors: [maxhandmade]
tags: [release, currency-switcher, privacy, geolocation]
date: 2026-09-07T13:25
---

2.2.0 is a privacy fix. On a store without a local MaxMind database, geolocation could send every new visitor's IP address to a remote geolocation service. It no longer can. Geolocation is also switched off by default on new installs. If you rely on it, read the last section: on some stores it now needs one setting to keep working.

{/* truncate */}

## What changed

To detect a visitor's currency, the plugin asks WooCommerce which country the visitor is in. When WooCommerce had no local MaxMind database, that question could fall back to a remote geolocation service, which received the visitor's IP address. WooCommerce's own storefront code switches that fallback off; this plugin called the same function with its defaults, so for this feature the fallback stayed on. 2.2.0 switches it off too. Detection now uses only CloudFlare's country header or a MaxMind database on your own server — **nothing about the visitor leaves your server**.

## Geolocation starts off on new installs

Working out a visitor's country from their IP address is data processing, so on a new install it is now something you switch on deliberately, on the **Advanced** tab. **Stores that update keep the setting they already had** — nothing is switched off for you.

## ⚠️ If you use geolocation without CloudFlare or MaxMind

Detection will now find nothing instead of asking a remote service, and visitors keep your base currency until they choose one. To keep the feature, add a free MaxMind GeoLite2 licence key under **WooCommerce > Settings > Integration > MaxMind Geolocation**. WooCommerce then downloads the database and keeps it up to date, and every lookup happens on your own server. The Advanced tab now states what geolocation needs, whether or not it is switched on. Details: [Advanced settings](/docs/advanced-settings) and [Currency detection](/docs/currency-detection).

[2.2.0 on GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.2.0)
