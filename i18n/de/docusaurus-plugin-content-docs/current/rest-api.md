---
sidebar_position: 12
title: "REST-API-Referenz"
---

# REST-API-Referenz

**Namespace:** `mhmcs/v1` · **Basis-URL:** `/wp-json/mhmcs/v1/`

Die meisten Websites rufen diese Endpunkte nie direkt auf – der Umschalter, das Produkt-Widget und der Cache-Kompatibilitätsmodus nutzen sie alle automatisch. Sie sind hier für alle dokumentiert, die eine Integration entwickeln oder ein Caching-Setup debuggen.

## Öffentliche Endpunkte

### GET `/rates` – entfernt

*Entfernt in 2.1.0.* Der öffentliche, nicht authentifizierte Endpunkt `/mhmcs/v1/rates` wurde entfernt und hat keinen Ersatz – er lieferte nur Informationen, die die Seite ohnehin schon in ihren Preisen anzeigt. Die authentifizierten Routen `/rates/sync` und `/rates/preview`, die der Einstellungsbildschirm verwendet, sind davon nicht betroffen.

### POST `/convert`

*Seit 1.1.0.* Diesen Endpunkt ruft der Browser automatisch auf, wenn der [Cache-Kompatibilitätsmodus](/docs/advanced-settings) aktiv ist – er fragt die echten Preise aller Produkte ab, die auf einer ansonsten in der Basiswährung gecachten Seite markiert sind. Sende `product_ids` (bis zu 50 pro Anfrage; der Server setzt diese Obergrenze unabhängig davon durch, was du sendest) und optional eine `currency`; lässt du sie weg, [ermittelt](/docs/currency-detection) der Server die Währung des Besuchers für dich. Die Antwort gibt zurück, welche Währung verwendet wurde, sowie das HTML mit Preisen für jede ID:

```json
{
    "currency": "EUR",
    "detected": false,
    "prices": { "101": "<span class=\"woocommerce-Price-amount amount\">€13,68</span>" }
}
```

`detected` ist nur dann `true`, wenn der Server die Währung selbst ermittelt hat (die Geolokalisierung war erfolgreich und in der Anfrage wurde kein `currency` gesendet) – bei einer explizit angegebenen `currency` ist es `false`, und `false`, wenn auch die Ermittlung kein Ergebnis geliefert hat. Das ist wichtig, weil das Schreiben des Cookies im Browser davon abhängt: `price-converter.js` speichert das Cookie nur, wenn `detected: true` gilt. So wird eine fehlgeschlagene Ermittlung nicht auf die Basiswährung festgeschrieben, und die Geolokalisierung wird beim nächsten Seitenaufruf des Besuchers erneut versucht.

Der Endpunkt ist bewusst nicht authentifiziert – die Seiten, die er bedient, werden von abgemeldeten Besuchern aufgerufen, die keine Nonce senden können –, aber eng begrenzt: nur bereits öffentliches Produkt-HTML, keine serverseitigen Schreibvorgänge und ein Ratenlimit pro Adresse von **120 Anfragen pro Minute**, das über den Filter `mhmcs_convert_rate_limit` angepasst werden kann. Wird es überschritten, wird `429` mit einem `Retry-After`-Header zurückgegeben. Eine ausführliche Erklärung, warum er so gestaltet ist, findest du in unserer FAQ unter der Frage [„Gibt es ein Limit, wie oft der Umrechnungs-Endpunkt aufgerufen werden kann?“](/docs/faq).

## Admin-Endpunkte

> Alle diese Endpunkte erfordern die Berechtigung `manage_woocommerce`. Der Einstellungsbildschirm selbst ist ein Client genau dieser Routen.

| Methode | Endpunkt | Funktion |
|---|---|---|
| GET | `/settings` | Plugin-Einstellungen abrufen |
| POST | `/settings` | Plugin-Einstellungen speichern |
| GET | `/currencies` | Basiswährung und konfigurierte Währungen abrufen |
| POST | `/currencies` | Währungen speichern |
| POST | `/rates/sync` | Kurse von der Quelle abrufen und aktualisieren |
| GET | `/rates/preview` | Roher und effektiver Kurs pro Währung |
| POST | `/rates/preview` | Dasselbe für eine übermittelte (nicht gespeicherte) Konfiguration – speichert nichts |
| POST | `/cache-notice/snooze-anomaly` | Admin-Hinweis zu Cache-Anomalien zurückstellen *(2.1.0)* |
| POST | `/cache-notice/snooze-fragments` | Admin-Hinweis zu Cache-Fragmenten zurückstellen *(2.1.0)* |

## Währung in der WooCommerce-Produkt-API

Füge den WooCommerce-eigenen Produkt-Endpunkten einen Parameter `currency` hinzu, um umgerechnete Preise zu erhalten:

```bash
curl https://yourstore.com/wp-json/wc/v3/products?currency=EUR
```

`price`, `regular_price` und `sale_price` werden umgerechnet zurückgegeben, und ein Feld `currency_code` wird hinzugefügt. Lässt du den Parameter weg oder sendest du eine Währung, die dein Shop nicht anbietet, wird die Antwort auf deine Basiswährung festgelegt – das Ergebnis hängt also nur von der Anfrage ab, niemals von den Cookies des Aufrufers.

Die vollständige FAQ findest du auf der Seite [FAQ](/docs/faq); die vollständige Liste der bekannten Einschränkungen
auf der Seite [Bekannte Einschränkungen](/docs/known-limits).
