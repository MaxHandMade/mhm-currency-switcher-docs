---
slug: currency-switcher-v2.3.0-release
title: "Currency Switcher 2.3.0 — ein tastaturfreundlicher Umschalter und umgerechnete Preise, die dem echten Preis folgen"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-04T02:30
---

2.3.0 macht den Währungsumschalter per Tastatur bedienbar, blendet die umgerechneten Preise aus, sobald der eigene Preis eines Produkts ausgeblendet ist, und lädt weniger auf Seiten, die den Umschalter nicht brauchen. Außerdem wird die WooCommerce-Mindestversion auf 9.1 angehoben – prüfe also deine WooCommerce-Version, bevor du aktualisierst.

{/* truncate */}

## WooCommerce 9.1 oder neuer

Das Plugin gab bisher an, WooCommerce 7.4 zu unterstützen, aber das wurde nirgends getestet. Die Mindestversion nennt jetzt die älteste WooCommerce-Version, die die automatisierten Tests des Plugins tatsächlich installieren: **9.1**. Wenn dein Shop WooCommerce 7.4–9.0 verwendet, aktualisiere zuerst WooCommerce. Die vollständige Liste der Voraussetzungen findest du auf der [Installationsseite](/docs/installation).

## Der Umschalter funktioniert per Tastatur

Du konntest den Umschalter mit Tab erreichen und mit Enter öffnen, aber mit keiner Taste eine Währung auswählen. Jetzt öffnen **Enter**, **Leertaste**, **↓** oder **↑** die Liste bei der aktuellen Währung. Mit **↑ ↓ Pos1 Ende** bewegst du dich darin, **Enter** oder **Leertaste** wählt eine Währung aus, und **Escape** schließt die Liste, ohne etwas zu ändern. Der Tastaturfokus wird umrandet, auch wenn der Umschalter in einem Navigationsmenü sitzt, wo er bisher unsichtbar war. Das funktioniert genauso im Shortcode, im Elementor-Widget und im Menüeintrag. Siehe [Anzeigeoptionen](/docs/display-options).

## Umgerechnete Preise werden ausgeblendet, wenn der Preis es ist

Wenn ein Theme oder Plugin den Preis eines Produkts ausblendete (ein Katalog- oder Wartungsmodus, „Anmelden, um Preise zu sehen“), verschwand der Preis von WooCommerce, aber die umgerechneten Preise wurden weiterhin darunter angezeigt. Das Produktpreis-Widget folgt jetzt dem eigenen Preis des Produkts. Wenn der Preis ausgeblendet oder durch eine Meldung ersetzt wird, verschwinden auch die umgerechneten Preise. Wenn ein Plugin dem Preis nur etwas hinzufügt, etwa einen Hinweis „inkl. MwSt.“, bleiben sie erhalten.

## Weniger zu laden, wo der Umschalter nicht verwendet wird

Wenn Preise auf deinem Server umgerechnet werden (Cache-Kompatibilität aus, angemeldete Kunden, Warenkorb und Kasse), wird das Skript des Umschalters jetzt nur noch auf Seiten geladen, die einen Umschalter anzeigen. Wo der Browser die Preise umrechnet (Cache-Kompatibilität an, was die Standardeinstellung ist, für nicht angemeldete Besucher, außerhalb von Warenkorb und Kasse), ändert sich nichts.

[2.3.0 auf GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.3.0)
