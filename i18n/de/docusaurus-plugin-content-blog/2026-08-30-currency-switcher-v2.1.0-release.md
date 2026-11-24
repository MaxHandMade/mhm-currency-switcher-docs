---
slug: currency-switcher-v2.1.0-release
title: "Currency Switcher 2.1.0 — auf WordPress.org, mit einem einheitlichen Präfix"
authors: [maxhandmade]
tags: [release, currency-switcher, css, rest-api]
date: 2026-08-30T15:27
---

MHM Currency Switcher ist jetzt auf WordPress.org gelistet, und 2.1.0 ist die Version, mit der es dort angekommen ist — ab jetzt bietet WordPress die Updates wie bei jedem anderen Plugin an. Das Release schließt außerdem eine Bereinigung der Benennungen ab, die drei Dinge ändert, auf die sich eigener Code verlassen kann. Wenn du also CSS, JavaScript oder PHP für das Plugin geschrieben hast, lies den ersten Abschnitt, bevor du aktualisierst.

{/* truncate */}

## Vor dem Update: drei Dinge haben Namen oder Form geändert

**CSS-Klassen.** Jede Klasse, die der Switcher verwendet, hat ihr Präfix von `mhm-cs-` zu `mhmcs-` geändert: Aus `.mhm-cs-switcher` wird `.mhmcs-switcher`, aus `.mhm-cs-dropdown` wird `.mhmcs-dropdown` und so weiter für jede Klasse. Für die alten Namen wird kein Alias beibehalten, daher greift eigenes CSS oder JavaScript, das für sie geschrieben wurde, nach dem Update nicht mehr. Die vollständige Liste findest du auf der Seite [CSS-Klassen](/docs/css).

**Der Wechselkurs-Fallback.** Wenn die Hauptquelle für Wechselkurse nicht erreichbar ist, stellt das Plugin jetzt eine einzige Anfrage an den täglichen Referenzkurs-Feed der Europäischen Zentralbank. Die in 2.0.0 eingeführte zweistufige Kette — zuerst Currency API, dann Frankfurter — entfällt. An der Abdeckung ändert sich nichts, rund dreißig Währungen, denn die EZB war bereits der letzte Schritt der alten Kette. Wenn dein Code die Fallback-Adresse filtert, ist das Argument `$source` des Filters `mhmcs_fallback_rates_url` jetzt immer `ecb`. Siehe [Währungen verwalten](/docs/managing-currencies).

**Der öffentliche Kurs-Endpunkt.** Die nicht authentifizierte REST-Route `GET /mhmcs/v1/rates` wurde entfernt; sie wiederholte, was die Seite bereits in ihren Preisen anzeigt. Die authentifizierten Routen, die der Einstellungsbildschirm verwendet, sind nicht betroffen. Siehe die [REST-API-Referenz](/docs/rest-api).

## Ruhigere Hinweise, am richtigen Ort

- Die beiden Warnungen zur Cache-Kompatibilität lassen sich vorübergehend ausblenden. Das Ausblenden entfernt eine Warnung nur für das Problem, das in diesem Moment erkannt wurde: Tritt später ein neues, anderes Cache-Problem auf, erscheint die Warnung wieder, statt dauerhaft stumm zu bleiben. *Später: Ab 2.2.1 bleibt eine Ausblendung bestehen, bis die Warnung behoben ist — siehe die [Hinweise zu 2.2.1](/blog/currency-switcher-v2.2.1-release).*
- Der Hinweis auf fehlendes WooCommerce und die beiden Cache-Warnungen erscheinen jetzt nur noch auf den Bildschirmen, auf die sie gehören, statt auf jedem Admin-Bildschirm, und nur für Personen, die darauf reagieren können: Benutzer, die Plugins aktivieren dürfen, beim ersten, Benutzer, die WooCommerce verwalten dürfen, bei den beiden anderen.

## Außerdem in diesem Release

- Die Migration der Einstellungen für Installationen, die nie über das Release 2026-03 hinaus aktualisiert wurden, wurde entfernt, zusammen mit den zugehörigen Zweigen für alte Optionen in der Deinstallationsroutine. Alle seit 1.0.0 (2026-07) veröffentlichten Versionen sind nicht betroffen.
- Die letzten im Plugin verbliebenen Namen `mhm-cs-`, `mhm_cs_` und `mhm_currency_switcher_` wurden auf das Präfix `mhmcs` umbenannt.
- Das Release-Paket enthält die kompilierten Übersetzungsdateien nicht mehr. *Später: 2.2.1 bringt die türkische Übersetzung zurück ins Plugin — siehe die [Hinweise zu 2.2.1](/blog/currency-switcher-v2.2.1-release).*

[2.1.0 auf GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.1.0)
