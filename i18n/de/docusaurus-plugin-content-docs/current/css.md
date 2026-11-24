---
sidebar_position: 11
title: "Anpassen mit CSS"
---

# Anpassen mit CSS

Füge deine Überschreibungen unter **Design > Customizer > Zusätzliches CSS** oder im Stylesheet deines Themes hinzu. Am schnellsten findest du, was du brauchst, indem du den Umschalter mit den Entwicklertools deines Browsers untersuchst – die unten aufgeführten Klassen sind genau die, die tatsächlich im vom Plugin ausgegebenen Markup vorkommen, hier beruht also nichts auf Vermutungen.

*Umbenannt in 2.1.0.* Alle Klassen auf dieser Seite trugen früher das Präfix `mhm-cs-` und tragen jetzt `mhmcs-`. Für die alten Namen wird kein Alias beibehalten, daher greift eigenes CSS oder JavaScript, das für die alten Schreibweisen geschrieben wurde, nach dem Update nicht mehr – stelle deine Selektoren auf die unten stehenden Namen um.

## Häufige Änderungen

**Den Umschalter-Button umfärben:**

```css
.mhmcs-selected {
    background-color: #1a1a2e;
    color: #ffffff;
    border-color: #16213e;
}
```

**Das Dropdown verbreitern:**

```css
.mhmcs-switcher .mhmcs-dropdown {
    min-width: 200px;
}
```

Die Positionierungsregeln des Dropdowns verwenden `!important` (um Konflikte mit Themes zu überstehen). Zum Überschreiben von Position oder Sichtbarkeit brauchst du daher in der Regel einen Selektor, der mindestens so spezifisch ist wie der oben gezeigte, statt eines bloßen `.mhmcs-dropdown`.

**Den Umschalter in einem Navigationsmenü ausrichten:**

```css
.menu-item.mhmcs-menu-item .mhmcs-dropdown {
    left: auto;
    right: 0;
    min-width: 160px;
}
```

**Die Größe des Produktpreis-Widgets ändern:**

```css
.mhmcs-product-prices {
    font-size: 16px;
    color: #333;
}
```

Unterhalb von 480px stapelt sich das Widget bereits von selbst vertikal und blendet seine Trennzeichen aus – für diesen Breakpoint ist kein zusätzlicher Aufwand nötig.

## Klassenreferenz

| Bereich | Klassen |
|---|---|
| Umschalter-Container / Größe | `.mhmcs-switcher`, `.mhmcs-size--small`, `.mhmcs-size--medium`, `.mhmcs-size--large` |
| Umschalter-Button / Dropdown | `.mhmcs-selected`, `.mhmcs-arrow`, `.mhmcs-label`, `.mhmcs-flag`, `.mhmcs-dropdown`, `.mhmcs-dropdown.mhmcs-open`, `.mhmcs-option`, `.mhmcs-active` |
| Navigationsmenü-Eintrag | `.menu-item.mhmcs-menu-item` |
| Produktpreis-Widget | `.mhmcs-product-prices`, `.mhmcs-product-price`, `.mhmcs-separator`, `.mhmcs-amount` |

Dies sind alles Frontend-Klassen. Klassen für Variantenpreise wie `mhmcs-variation-prices` sind auf dieser Seite nicht enthalten: Sie gehören zum reinen Admin-Bereich für Variantenpreise, der nur auf dem WooCommerce-Bildschirm „Produkte“ erscheint.
