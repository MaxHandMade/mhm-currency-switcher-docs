---
slug: currency-switcher-v2.3.1-release
title: "Currency Switcher 2.3.1 — Deutsch und Spanisch sowie Übersetzungen, die jeden Bildschirm erreichen"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-21T09:40
---

2.3.1 fügt deutsche und spanische Übersetzungen hinzu und ändert, welche Übersetzung das Plugin verwendet, wenn mehr als eine vorhanden ist. Sonst ändert sich nichts, und es gibt nichts zu konfigurieren.

{/* truncate */}

## Deutsch und Spanisch

Das Plugin wird jetzt auf Englisch, Türkisch, Deutsch und Spanisch ausgeliefert. Auf einer deutsch- oder spanischsprachigen Website erscheinen die Einstellungsseite, die Menübezeichnungen, die Admin-Hinweise und der Switcher in dieser Sprache. Siehe [Sprachen](/docs/installation#sprachen).

## WordPress.org-Übersetzungen erreichen die Einstellungsseite

Übersetzungen, die auf [translate.wordpress.org](https://translate.wordpress.org/projects/wp-plugins/mhm-currency-switcher/) erstellt werden, kommen als Sprachpaket an. Bisher hat die Einstellungsseite das Sprachpaket für die Sprachen, die das Plugin mitliefert, ignoriert und immer die plugineigene Übersetzung angezeigt, sodass eine auf translate.wordpress.org vorgenommene Korrektur sie nie erreicht hat. Das Sprachpaket hat jetzt auf jedem Bildschirm Vorrang.

## Fehlende Texte greifen auf die Übersetzung des Plugins zurück

Ein Sprachpaket kann hinter einer neuen Version zurückbleiben: Texte, die mit der Version hinzugekommen sind, werden auf Englisch angezeigt, bis die Übersetzer aufgeholt haben. Jetzt verwenden diese Texte stattdessen die plugineigene Übersetzung, und das Sprachpaket hat weiterhin überall dort Vorrang, wo es den Text enthält.

## WordPress 6.6 und 6.7

Unter WordPress 6.6 und 6.7 blieben die Menübezeichnungen, die Admin-Hinweise und der Switcher auf Englisch, selbst wenn das Plugin eine Übersetzung für deine Sprache mitbrachte. Sie werden jetzt auch dort übersetzt, sodass das Plugin auf jeder unterstützten Version gleich aussieht.

[2.3.1 auf GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.3.1)
