---
sidebar_position: 4
title: "Anzeigeoptionen"
slug: /display-options
---

# Anzeigeoptionen

**WooCommerce > MHM Currency > Anzeigeoptionen**

## Darstellung des Umschalters

| Einstellung | Funktion | Standard |
|---|---|---|
| **Flaggensymbol anzeigen** | Zeigt eine Landesflagge neben der Währung an | An |
| **Währungsnamen anzeigen** | Zeigt den vollständigen Namen an (z. B. „US-Dollar“) | **Aus** |
| **Währungssymbol anzeigen** | Zeigt das Symbol an (z. B. „$“, „€“) | An |
| **Währungscode anzeigen** | Zeigt den ISO-Code an (z. B. „USD“, „EUR“) | An |

Die Beschriftung wird aus den aktivierten Bestandteilen in dieser Reihenfolge zusammengesetzt: Symbol → Code → Name. Wenn du alle vier deaktivierst, bleibt die Beschriftung nicht leer – als Ersatz wird der Währungscode angezeigt.

## Größe des Umschalters

| Größe | Schriftgröße |
|---|---|
| Klein | 12px |
| Mittel (Standard) | 14px |
| Groß | 16px |

## Bedienung per Tastatur

Der Umschalter lässt sich ohne Maus bedienen. Springe mit der Tabulatortaste dorthin und drücke dann **Enter**, **Leertaste**, **↓** oder **↑**, um die Liste bei der aktuellen Währung zu öffnen. Mit **↑ ↓ Pos1 Ende** bewegst du dich durch die Liste, **Enter** oder **Leertaste** wählt eine Währung aus und **Escape** schließt die Liste, ohne etwas zu ändern. Der Tastaturfokus wird umrandet, auch wenn sich der Umschalter in einem Navigationsmenü befindet.

## Produktpreis-Widget

Eine Leiste unter dem Hauptpreis auf Produktseiten, die den Preis gleichzeitig in mehrere Währungen umgerechnet anzeigt.

| Einstellung | Funktion |
|---|---|
| **Produktpreis-Widget aktivieren** | Schaltet das Widget ein oder aus |
| **Anzuzeigende Währungen** | Wähle bis zu 5 Währungen aus |
| **Flaggen im Widget anzeigen** | Zeigt neben jedem Preis eine Flagge an |

Wenn das Widget aktiviert ist, erscheint es automatisch in der Preisübersicht des Produkts – du musst dafür keinen Shortcode hinzufügen. Es bleibt ausgeblendet, wenn keine Währung ausgewählt ist. Außerdem wird es immer dann ausgeblendet, wenn auch der eigentliche Produktpreis ausgeblendet ist: Wenn ein Theme oder Plugin Preise verbirgt (ein Katalog- oder Wartungsmodus, „Zum Anzeigen der Preise anmelden“), verschwinden auch die umgerechneten Preise. Ein Plugin, das dem Preis lediglich etwas hinzufügt, etwa einen Zusatz „inkl. MwSt.“, blendet es nicht aus.

**Beispiel:**

```
Product price: $500.00

€459.20 | £395.10 | ¥75,300
```

Eine Vorschau unten im Tab spiegelt deine aktuellen Einstellungen wider; sie ist eine vereinfachte Darstellung, und das tatsächliche Aussehen hängt von deinem Theme ab.

## Wechseln ohne Neuladen der Seite

Wenn der Cache-Kompatibilitätsmodus aktiviert ist (Standard – siehe [Erweiterte Einstellungen](/docs/advanced-settings)) und ein Besucher auf einer beliebigen Seite außer der Warenkorb-, Kassen- oder Kontoseite eine andere Währung auswählt, wird die Seite nicht neu geladen: Das Plugin setzt das Cookie, rechnet die sichtbaren Preise direkt auf der Seite um und aktualisiert den Mini-Warenkorb. Auf der Warenkorb-, Kassen- oder Kontoseite, auf einer Seite, auf der ein Theme oder Plugin die Warenkorb-Konstante von WooCommerce definiert (siehe die [FAQ](/docs/faq)), bei angemeldeten Besuchern oder bei deaktivierter Cache-Kompatibilität wird die Seite wie bisher neu geladen.

Die vollständigen FAQ findest du auf der Seite [FAQ](/docs/faq); die vollständige Liste der bekannten Einschränkungen findest du
auf der Seite [Bekannte Einschränkungen](/docs/known-limits).
