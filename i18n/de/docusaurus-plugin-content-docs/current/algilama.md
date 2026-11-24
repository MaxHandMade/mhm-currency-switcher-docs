---
sidebar_position: 9
title: "Währungserkennung"
slug: /currency-detection
---

# Währungserkennung

Jede Stelle der Website, an der Preise erscheinen – Seitenausgaben, der Warenkorb, der Convert-Endpunkt –, ermittelt die Währung des Besuchers über genau dieselbe vierstufige Kette, in dieser Reihenfolge:

1. **Cookie** – höchste Priorität.
2. **URL-Parameter** (`?currency=EUR`).
3. **Geolokalisierung** – nur wenn sie unter [Erweiterte Einstellungen](/docs/advanced-settings) aktiviert ist.
4. **Basiswährung** – der Fallback.

Ein in einer beliebigen Stufe gefundener Code wird verworfen (und die Kette geht weiter), sofern er nicht entweder die Basiswährung des Shops oder eine von dir aktivierte Währung ist. Es gibt genau eine Implementierung dieser Regel, die von allen Aufrufern gemeinsam genutzt wird – keine Seite und kein Endpunkt hat eine eigene Kopie, die unbemerkt davon abweichen könnte.

## Cookie

Es gibt **drei** verschiedene Stellen, an denen dieses Cookie geschrieben wird – wenn ein Besucher in der falschen Währung festhängt, hängt die Lösung davon ab, welche davon beteiligt ist:

1. **Auswahl im Umschalter.** Wenn ein Besucher eine Währung aus dem Dropdown auswählt, schreibt der Browser (`switcher.js`) das Cookie selbst.
2. **Geolokalisierung, serverseitig.** `detect_from_geolocation()` stellt das Ergebnis in eine Warteschlange, und `prime_currency_cookie()` – eingehängt in `template_redirect`, Priorität 0 – schreibt es in das Cookie, **es sei denn, die aktuelle Ausgabe wird gleich von einem Seiten-Cache gespeichert.** Bei einer cachebaren Ausgabe (Cache-Kompatibilitätsmodus aktiv, Besucher abgemeldet, jede Frontend-Seite außer Warenkorb, Kasse oder Kontoseite – und keine Seite, auf der ein Theme oder Plugin die Warenkorb-Konstante von WooCommerce definiert, siehe [FAQ](/docs/faq)) wird dieser Schreibvorgang absichtlich übersprungen: Würde er dort erfolgen, würde die per Geolokalisierung ermittelte Währung eines einzelnen Besuchers in das gecachte HTML eingebrannt und an alle ausgeliefert, die diese Seite danach laden.
3. **Geolokalisierung, clientseitig.** Genau bei den cachebaren Ausgaben, bei denen Schritt 2 zurücktritt, ruft der Browser den [Convert-Endpunkt](/docs/rest-api) selbst auf; liefert die Antwort `detected: true` zurück, schreibt stattdessen `price-converter.js` das Cookie. Die Schritte 2 und 3 ergänzen sich und überschneiden sich nicht – bei jeder Ausgabe wird immer nur einer von beiden ausgeführt.

Alle drei schreiben dieselben Attribute (30 Tage, `path=/`, `SameSite=Lax`, `Secure` nur bei HTTPS) – bewusst synchron gehalten über zwei separate Skripte und die PHP-Seite hinweg, denn ein einziges abweichendes Attribut führt dazu, dass die Auswahl eines Besuchers in einem Modus unbemerkt nicht mehr gespeichert wird, in den anderen aber schon.

| Eigenschaft | Wert |
|---|---|
| Name | `mhmcs_currency` |
| Lebensdauer | 30 Tage |
| Pfad | `/` (gesamte Website) |
| Secure | Ja, auf HTTPS-Websites |
| SameSite | Lax |
| HttpOnly | Nein |

## URL-Parameter

Wenn du `?currency=EUR` an einen Link anhängst, wird für diesen Seitenaufruf eine Währung festgelegt:

```
https://yourstore.com/product-page/?currency=EUR
https://yourstore.com/shop/?currency=USD
```

Praktisch für Kampagnen-Links. Der Parameter wirkt für diese Anfrage **nur lesend** – er schreibt absichtlich kein Cookie, sodass beim nächsten Seitenaufruf des Besuchers wieder das gilt, was das Cookie (oder die Geolokalisierung) vorgibt, nicht der Parameter. Ist bereits ein Cookie gesetzt, hat der Parameter überhaupt keine Wirkung, da das Cookie zuerst geprüft wird. Verwende den Umschalter selbst, wenn eine Auswahl erhalten bleiben soll.

## Geolokalisierung

Wird nur ausgeführt, wenn sie aktiviert ist, und nur, wenn noch kein Cookie vorhanden ist. Unter [Erweiterte Einstellungen](/docs/advanced-settings) findest du die Abfragereihenfolge von CloudFlare/MaxMind und was passiert, wenn kein Land ermittelt werden kann.

## Basiswährung

Der Fallback, wenn keine der obigen Stufen eine verwendbare Währung ergeben hat – also die Basiswährung, die in WooCommerce selbst eingestellt ist.

## Eine Ausnahme: der Convert-Endpunkt

Die browserseitige [`POST /convert`](/docs/rest-api)-Anfrage des Cache-Kompatibilitätsmodus durchläuft dieselbe Kette, allerdings sind für diese eine Anfrage sowohl das Schreiben des Cookies als auch die Geolokalisierung deaktiviert – in diesem Modus ist der Browser für das Cookie zuständig, und ein serverseitiger Schreibvorgang würde dort mit ihm konkurrieren.
