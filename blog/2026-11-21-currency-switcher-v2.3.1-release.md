---
slug: currency-switcher-v2.3.1-release
title: "Currency Switcher 2.3.1 — German and Spanish, and translations that reach every screen"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-21T09:40
---

2.3.1 adds German and Spanish translations and changes which translation the plugin uses when there is more than one. Nothing else changes, and there is nothing to configure.

{/* truncate */}

## German and Spanish

The plugin now ships in English, Turkish, German and Spanish. On a German or Spanish site the settings screen, the menu labels, the admin notices and the switcher appear in that language. See [Languages](/docs/installation#languages).

## WordPress.org translations reach the settings screen

Translations made on [translate.wordpress.org](https://translate.wordpress.org/projects/wp-plugins/mhm-currency-switcher/) arrive as a language pack. Until now the settings screen ignored the pack for the languages the plugin ships, and always showed the plugin's own translation, so a correction made on translate.wordpress.org never reached it. The language pack now takes precedence on every screen.

## Missing text falls back to the plugin's translation

A language pack can lag behind a new release: text added in the release shows in English until translators catch up. Now that text uses the plugin's own translation instead, and the language pack still wins wherever it has the text.

## WordPress 6.6 and 6.7

On WordPress 6.6 and 6.7, the menu labels, admin notices and the switcher stayed in English even when the plugin carried a translation for your language. They are now translated there too, so the plugin looks the same on every supported version.

[2.3.1 on GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.3.1)
