---
sidebar_position: 2
title: "Installation"
slug: /installation
---

# Installation und Voraussetzungen

## Voraussetzungen

| Voraussetzung | Mindestversion |
|---|---|
| WordPress | 6.6 |
| PHP | 7.4 |
| WooCommerce | 9.1 |

Dies ist die einzige Seite dieser Website, auf der diese Mindestanforderungen genannt werden – schau sie dir hier an, nicht anderswo.

## Plugin installieren

1. Lade den Ordner `mhm-currency-switcher` nach `/wp-content/plugins/` hoch oder installiere das Plugin direkt über die Plugin-Seite von WordPress.
2. Aktiviere es über das Menü **Plugins**.
3. Stelle sicher, dass WooCommerce installiert und aktiv ist – ohne WooCommerce tut das Plugin nichts und zeigt einen entsprechenden Hinweis im Admin-Bereich an.
4. Gehe zu **WooCommerce > MHM Currency**.

Du benötigst die Berechtigung `manage_woocommerce`, um die Einstellungsseite zu sehen (die Rollen „Shop-Manager“ und „Administrator“ haben sie standardmäßig).

## Was du direkt nach der Aktivierung erhältst

- **Die Währungsliste ist anfangs leer.** Es sind keine Währungen voreingestellt; du fügst die gewünschten selbst hinzu.
- Die Geolokalisierung ist anfangs **deaktiviert** (seit 2.2.0). Das Land eines Besuchers anhand seiner IP-Adresse zu ermitteln, ist eine Datenverarbeitung, daher bleibt es dir überlassen, sie bewusst einzuschalten. Shops, die aktualisieren, behalten ihre bisherige Auswahl.
- Das Erscheinungsbild des Umschalters startet mit diesen Standardwerten: Flagge **an**, Symbol **an**, Code **an**, Währungsname **aus**, Größe **Mittel**.
- Der Cache-Kompatibilitätsmodus ist anfangs **aktiviert** – was er bewirkt, erfährst du unter [Erweiterte Einstellungen](/docs/advanced-settings).

Die Basiswährung deines Shops stammt immer aus den Einstellungen von WooCommerce selbst (**WooCommerce > Einstellungen > Allgemein > Währungsoptionen**). Du kannst die Basiswährung nicht zur Währungsliste des Plugins hinzufügen – sie ist bereits der Ausgangspunkt der Umrechnung.

## Die vier Einstellungs-Tabs

| Tab | Inhalt |
|---|---|
| **Währungen verwalten** | Die Währungsliste: Kurs, Gebühr, Rundung, Reihenfolge |
| **Anzeigeoptionen** | Das Erscheinungsbild des Umschalters und das Produktpreis-Widget |
| **Erweitert** | Geolokalisierung, der Zeitplan für die automatische Kursaktualisierung und Cache-Kompatibilität |
| **Anleitung** | Kopierbare Snippets für jede Stelle deiner Website, an der der Umschalter platziert werden kann |

Bei nicht gespeicherten Änderungen erscheint oben auf der Seite eine Leiste. **Änderungen speichern** wird sowohl in dieser Leiste als auch unten auf der Seite angezeigt und speichert alle vier Tabs in einer einzigen Anfrage.

## Sprachen

Das Plugin wird auf Englisch, Türkisch, Deutsch und Spanisch ausgeliefert, und auf einer Website in einer dieser Sprachen erscheint das gesamte Plugin unter jeder unterstützten WordPress-Version (6.6 und neuer) in dieser Sprache. Wenn es auf WordPress.org ein Sprachpaket für deine Sprache gibt, hat dieses Paket Vorrang, und die eigene Übersetzung des Plugins ergänzt alle Texte, die das Paket noch nicht enthält. Übersetzungen in weitere Sprachen entstehen auf [translate.wordpress.org](https://translate.wordpress.org/projects/wp-plugins/mhm-currency-switcher/), wo jeder mit einem WordPress.org-Konto mitwirken kann.

Die vollständigen FAQ findest du auf der Seite [FAQ](/docs/faq); die vollständige Liste der bekannten Einschränkungen findest du
auf der Seite [Bekannte Einschränkungen](/docs/known-limits).
