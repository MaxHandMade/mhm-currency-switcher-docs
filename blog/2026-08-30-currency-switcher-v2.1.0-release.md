---
slug: currency-switcher-v2.1.0-release
title: "Currency Switcher 2.1.0 — On WordPress.org, with one prefix everywhere"
authors: [maxhandmade]
tags: [release, currency-switcher, css, rest-api]
date: 2026-08-30T15:27
---

MHM Currency Switcher is now listed on WordPress.org, and 2.1.0 is the version it arrived with — WordPress offers its updates like any other plugin's from here on. The release also finishes a naming clean-up that changes three things custom code can rely on, so if you have written CSS, JavaScript or PHP against the plugin, read the first section before you update.

{/* truncate */}

## Before you update: three things changed name or shape

**CSS classes.** Every class the switcher uses changed its prefix from `mhm-cs-` to `mhmcs-`: `.mhm-cs-switcher` is now `.mhmcs-switcher`, `.mhm-cs-dropdown` is now `.mhmcs-dropdown`, and so on for every class. No alias is kept for the old names, so custom CSS or JavaScript written against them stops matching once you update. The full list is on the [CSS classes](/docs/css) page.

**The exchange-rate fallback.** When the main rate source cannot be reached, the plugin now makes a single request to the European Central Bank's daily reference feed. The two-stage chain added in 2.0.0 — Currency API, then Frankfurter — is gone. Coverage does not change, roughly thirty currencies, because the ECB was already the last step of the old chain. If your code filters the fallback address, the `mhmcs_fallback_rates_url` filter's `$source` argument is now always `ecb`. See [Managing currencies](/docs/managing-currencies).

**The public rates endpoint.** The unauthenticated `GET /mhmcs/v1/rates` REST route was removed; it repeated what the page already shows in its prices. The authenticated routes the settings screen uses are unaffected. See the [REST API reference](/docs/rest-api).

## Quieter notices, in the right place

- The two cache-compatibility warnings can be snoozed. Snoozing clears a warning only for the problem detected at that moment: if a new, different cache problem appears later, the warning comes back instead of staying silent for good. *Later: in 2.2.1 a snooze holds until the warning clears — see the [2.2.1 notes](/blog/currency-switcher-v2.2.1-release).*
- The WooCommerce-missing notice and the two cache warnings now appear only on the screens where they belong instead of on every admin screen, and only to people who can act on them: users who can activate plugins for the first, users who can manage WooCommerce for the other two.

## Also in this release

- The settings migration for installs that never updated past the 2026-03 release was removed, together with the matching old-option branches in the uninstall routine. Every version released since 1.0.0 (2026-07) is unaffected.
- The last `mhm-cs-`, `mhm_cs_` and `mhm_currency_switcher_` names left in the plugin were renamed to the `mhmcs` prefix.
- The release package no longer includes the compiled translation files. *Later: 2.2.1 puts the Turkish translation back into the plugin — see the [2.2.1 notes](/blog/currency-switcher-v2.2.1-release).*

[2.1.0 on GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.1.0)
