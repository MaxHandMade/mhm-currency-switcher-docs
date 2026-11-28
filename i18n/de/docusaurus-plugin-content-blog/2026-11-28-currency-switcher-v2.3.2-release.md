---
slug: currency-switcher-v2.3.2-release
title: "Currency Switcher 2.3.2 — sauberere Spaltenüberschriften, getestet mit WooCommerce 11.3"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-28T12:00
---

2.3.2 ist eine kleine Wartungsversion. Lange Spaltenüberschriften auf dem Tab „Währungen verwalten“ werden jetzt zwischen Silben getrennt, und das Plugin ist mit WooCommerce 11.3 getestet. Es gibt nichts zu konfigurieren.

{/* truncate */}

## Spaltenüberschriften werden nach Silben getrennt

Ist eine Spaltenüberschrift auf dem Tab **Währungen verwalten** zu lang für ihre Spalte, bricht sie in eine zweite Zeile um. Bisher geschah das an dem Buchstaben, der gerade den Rand erreichte – „Reihenfolge“ wurde zum Beispiel zu „Reihenf / olge“. Jetzt wird zwischen Silben getrennt und ein Bindestrich gesetzt: „Reihen- / folge“. Englische und türkische Überschriften passen weiterhin in eine Zeile.

## Getestet mit WooCommerce 11.3

Die automatischen Tests liefen mit WooCommerce 11.3.1 auf WordPress 7.1.5, mit und ohne HPOS, und waren erfolgreich. Der Plugin-Header „WC tested up to“ lautet jetzt 11.3.

[2.3.2 auf GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.3.2)
