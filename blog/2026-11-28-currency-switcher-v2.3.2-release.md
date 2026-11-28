---
slug: currency-switcher-v2.3.2-release
title: "Currency Switcher 2.3.2 — tidier column headings, tested with WooCommerce 11.3"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-28T12:00
---

2.3.2 is a small maintenance release. Long column headings on the Manage Currencies tab now break between syllables, and the plugin is tested with WooCommerce 11.3. There is nothing to configure.

{/* truncate */}

## Column headings break between syllables

When a column heading on the **Manage Currencies** tab is too long for its column, it wraps onto a second line. Until now it broke at whichever letter reached the edge, for example the German "Reihenfolge" (Order) split as "Reihenf / olge". It now breaks between syllables and adds a hyphen: "Reihen- / folge". English and Turkish headings fit on one line, as before.

## Tested with WooCommerce 11.3

The automated tests ran against WooCommerce 11.3.1 on WordPress 7.1.5, with and without HPOS, and passed. The plugin's "WC tested up to" header now says 11.3.

[2.3.2 on GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.3.2)
