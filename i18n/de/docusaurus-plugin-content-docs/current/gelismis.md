---
sidebar_position: 5
title: "Erweiterte Einstellungen"
slug: /advanced-settings
---

# Erweiterte Einstellungen

**WooCommerce > MHM Currency > Erweitert**

Dieser Tab enthält vier Einstellungen.

## Erkennung per Geolokalisierung

| Einstellung | Funktion |
|---|---|
| **Währungserkennung per Geolokalisierung aktivieren** | Erkennt das Land des Besuchers und zeigt die passende Währung an |

Die Ländererkennung prüft zwei Quellen nacheinander, und **keine davon sendet Daten über den Besucher an Stellen außerhalb deines Servers** (Wechselkurse sind ein eigenes Thema – siehe „Automatische Kursaktualisierung“ weiter unten):

1. **CloudFlare (primär)** – Wenn deine Website hinter CloudFlare läuft, wird der Ländercode aus dem Header `CF-IPCountry` gelesen. Keine Konfiguration nötig und schnell. Codes für unbekannte Länder und Tor-Exit-Nodes werden ignoriert.
2. **Lokale MaxMind-Datenbank (Fallback)** – Gibt es keinen CloudFlare-Header, wird stattdessen die MaxMind-GeoIP-Datenbankdatei von WooCommerce abgefragt, die **auf deinem eigenen Server gespeichert** ist. Dafür ist ein kostenloser Lizenzschlüssel erforderlich, den du unter **WooCommerce > Einstellungen > Integration > MaxMind Geolocation** einträgst.

**Wenn keine der beiden Quellen verfügbar ist:** Die Erkennung findet nichts, und der Besucher sieht die Basiswährung, bis er selbst eine Währung auswählt. Es wird kein Drittanbieter abgefragt. Der Tab „Erweitert“ weist direkt unter der Einstellung darauf hin – unabhängig davon, ob die Einstellung aktiviert ist oder nicht.

> **Geändert in 2.2.0.** Frühere Versionen haben WooCommerces `geolocate_ip()` mit den Standardargumenten aufgerufen. In einem Shop ohne MaxMind-Datenbank wurde dadurch die IP-Adresse jedes neuen Besuchers an einen externen Geolokalisierungsdienst gesendet. Version 2.2.0 schließt diesen Fallback. Wenn du dich ohne CloudFlare oder MaxMind-Datenbank auf die Geolokalisierung verlassen hast, findet sie jetzt nichts mehr – füge einen kostenlosen MaxMind-Lizenzschlüssel hinzu, um sie wiederherzustellen. WooCommerce lädt die Datenbankdatei von MaxMind herunter und aktualisiert sie regelmäßig; diese Anfrage enthält deinen Lizenzschlüssel, niemals die Adresse eines Besuchers, und jede spätere Abfrage findet auf deinem eigenen Server statt.

**MaxMind-Datenbank einrichten (kostenlos):**

1. Erstelle ein MaxMind-Konto und schließe die **GeoLite2**-Registrierung ab.
2. Erzeuge unter **Manage License Keys** einen Lizenzschlüssel.
3. Füge den Schlüssel unter **WooCommerce > Einstellungen > Integration > MaxMind Geolocation** ein und speichere.
4. WooCommerce lädt die Datenbank in einen `woocommerce_uploads/`-Ordner im Uploads-Verzeichnis deiner Website herunter – bei einer normalen Einzelinstallation ist das `wp-content/uploads/woocommerce_uploads/`; bei einer Unterseite in einer Multisite oder wenn der Uploads-Speicherort angepasst wurde, ist es stattdessen das eigene Uploads-Verzeichnis dieser Website. Der Dateiname beginnt absichtlich mit einem nicht vorhersagbaren Präfix, damit seine Adresse von außen nicht erraten werden kann – such die Datei also nicht im Stammverzeichnis des Uploads-Verzeichnisses.

**So funktioniert es:**

1. Die Erkennung läuft nur, wenn der Besucher noch kein Währungs-Cookie hat.
2. Der Ländercode wird einer Währung zugeordnet.
3. Ist diese Währung in deinem Shop nicht **aktiviert**, gilt die Erkennung als erfolglos und die Basiswährung wird verwendet.
4. Bei einer erfolgreichen Erkennung wird ein Cookie gesetzt, damit die Erkennung auf weiteren Seiten nicht erneut läuft.
5. Wählt der Besucher im Umschalter eine andere Währung, wird diese Auswahl im Cookie gespeichert und hat ab dann Vorrang vor der Geolokalisierung.

## Automatische Kursaktualisierung

Kurse können automatisch über das System für geplante Aufgaben von WordPress (WP-Cron) aktualisiert werden.

| Option | Wirkung |
|---|---|
| **Nur manuell** | Keine automatischen Aktualisierungen; die geplante Aufgabe wird entfernt |
| **Stündlich** | Aktualisiert einmal pro Stunde |
| **Zweimal täglich** | Aktualisiert zweimal am Tag |
| **Täglich** | Aktualisiert einmal am Tag |

Wenn du das Intervall änderst, wird die bestehende geplante Aufgabe gelöscht und neu geplant. Beim Deaktivieren des Plugins wird die Aufgabe vollständig entfernt.

WP-Cron ist kein echter System-Cron – er wird nur bei eingehendem Traffic ausgelöst. Richte auf einer Website mit wenig Traffic den Crontab deines Servers auf `wp-cron.php` ein, damit die Aktualisierungen planmäßig weiterlaufen.

Die Kursquellen benötigen keinen API-Schlüssel, daher gibt es in diesem Tab weder eine Anbieterauswahl noch ein Schlüsselfeld.

## Cache-Kompatibilitätsmodus

*Seit 1.1.0.*

Ein Seiten-Cache speichert das HTML, das dein Server für den ersten Anfragenden erzeugt hat. Werden Preise auf dem Server umgerechnet, bedeutet das: Alle späteren Besucher bekommen die Währung des ersten Besuchers ausgeliefert.

Der **Cache-Kompatibilitätsmodus**, standardmäßig aktiviert, verhindert das: Für abgemeldete Besucher wird jede Frontend-Seite außer Warenkorb, Kasse und Kontoseiten – einschließlich Shop-, Kategorie- und Produktseiten – immer in deiner **Basiswährung** ausgegeben, sodass dieselbe gecachte Seite für alle korrekt ist. Der Browser rechnet die angezeigten Preise anschließend, nach dem Laden der Seite, über eine Anfrage an dieses Plugin um. Definiert ein Theme oder Plugin die Warenkorb-Konstante von WooCommerce auf jeder Seite, greift das nicht mehr – das Plugin warnt dich dann im Adminbereich; siehe [FAQ](/docs/faq).

Die Aufteilung ist beabsichtigt: Nur *angezeigte* Preise werden im Browser umgerechnet. Warenkorb, Kasse, Bestellsummen, Bestell-E-Mails und die WooCommerce REST API werden immer auf dem Server berechnet, in der Währung, die der Kunde tatsächlich gewählt hat – so kann der abgerechnete Betrag nicht vom Browser aus verändert werden.

| Einstellung | Funktion |
|---|---|
| **Seiten in der Basiswährung cachen** | Wenn du diese Option deaktivierst, werden Preise wieder auf dem Server umgerechnet, wie vor 1.1.0 – was sich nicht gut mit einem Seiten-Cache-Plugin verträgt. Warenkorb, Kasse und Bestellsummen werden in jedem Fall auf dem Server umgerechnet. |

Das Deaktivieren des Modus stellt nicht exakt das Verhalten von 1.0.0 wieder her – die Korrekturen für Adminbereich, REST API und geplante Aufgaben bleiben in beiden Modi aktiv.

## Was passiert, wenn das Plugin entfernt wird

*Seit 1.3.0.*

| Einstellung | Funktion |
|---|---|
| **Alle Daten löschen, wenn das Plugin entfernt wird** | Standardmäßig deaktiviert. Bleibt die Option deaktiviert, bleiben deine Einstellungen sowie die bei jeder Bestellung gespeicherte Währung und der Wechselkurs erhalten, wenn das Plugin gelöscht wird. |

Diese bestellbezogenen Daten sind die einzige Grundlage für eine Verkaufshistorie in mehreren Währungen und können
nachträglich nicht wiederhergestellt werden. Deshalb musst du die zerstörerische Option bewusst wählen,
statt dass sie standardmäßig greift. Das Deaktivieren des Plugins löscht niemals
etwas; nur das Löschen tut das, und nur, wenn dieser Schalter aktiviert ist.

In einem Multisite-Netzwerk bereinigt der Schalter die Website, von der das Plugin entfernt wird.

Die vollständigen FAQ findest du auf der Seite [FAQ](/docs/faq); die vollständige Liste der bekannten Einschränkungen steht
auf der Seite [Bekannte Einschränkungen](/docs/known-limits).
