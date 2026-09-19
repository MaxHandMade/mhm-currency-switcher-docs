---
slug: currency-switcher-v2.2.1-release
title: "Currency Switcher 2.2.1 — Turkish inside the plugin, and cache warnings that stay put"
authors: [maxhandmade]
tags: [release, currency-switcher, translation, cache]
date: 2026-09-18T20:07
---

2.2.1 fixes two things you could see. On a Turkish site the plugin appeared in English, and the two cache-compatibility warnings kept clearing and coming back. Both are fixed, and there is nothing to do after you update.

{/* truncate */}

## The Turkish translation ships with the plugin

Installed from WordPress.org, the plugin appeared in English on a Turkish site: the release package left the compiled translation files out, and no WordPress.org language pack existed to take their place. They are back in the package. On WordPress 6.8 and later the whole plugin is Turkish. On 6.6 and 6.7 the settings screen is Turkish, but text that comes from the plugin's PHP code, such as the menu label, stays in English — see [Known limits](/docs/known-limits). Other languages can be added on [translate.wordpress.org](https://translate.wordpress.org/projects/wp-plugins/mhm-currency-switcher/).

## Cache warnings no longer come and go

The two cache-compatibility warnings used to clear, together with every administrator's snooze, whenever a page could not show the problem — a customer opening the cart, or you browsing the store while logged in — and the next page view brought them back. Each check now reaches one of three answers: the problem is there, the page is clean, or this page cannot tell. A warning keeps naming the first page the problem was seen on, and clears only when that same page renders without the problem, when that page no longer exists, or when you save cache compatibility switched off. **Snooze until this changes** now holds, and both warnings say when they clear. How each warning works is described in the [FAQ](/docs/faq).

[2.2.1 on GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.2.1)
