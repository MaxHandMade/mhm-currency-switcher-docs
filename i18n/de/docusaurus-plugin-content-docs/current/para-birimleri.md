---
sidebar_position: 3
title: "Währungen verwalten"
slug: /managing-currencies
---

# Währungen verwalten

**WooCommerce > MHM Currency > Währungen verwalten**

Hier legst du fest, welche Währungen dein Shop anbietet.

## Die Währungstabelle

| Spalte | Funktion |
|---|---|
| **Aktiviert** | Schaltet eine Währung ein oder aus. Deaktivierte Währungen erscheinen nicht im Währungsumschalter. |
| **Code** | Der ISO-4217-Code, die Flagge und der vollständige Währungsname. |
| **Kurs** | Kurstyp (Automatisch / Manuell) und der Kurswert. |
| **Aufschlag** | Ein zusätzlicher Aufschlag auf den Kurs (Keine / Prozent / Festbetrag). |
| **Rundung** | Die Rundungsregel, die auf den umgerechneten Betrag angewendet wird. |
| **Reihenfolge** | Pfeile nach oben/unten, um die Reihenfolge im Drop-down des Umschalters zu ändern. |
| **Aktionen** | Entfernt die Währung aus der Liste. |

Die Basiswährung ist hier **keine** eigene Zeile – sie wird oberhalb der Tabelle genannt und stammt aus
**WooCommerce > Einstellungen > Allgemein**. Im Shop ist sie der erste Eintrag im Umschalter.

## Was der Kunde sieht

*Seit 1.3.0.*

Unter jeder Zeile steht eine Vorschauzeile: `Customer sees: 100.00 <base> → …`. Sie wird auf dem
Server mit dem Preisformatierer des Shops selbst berechnet und nicht im Browser geschätzt. Daher wendet sie denselben
Kurs, Aufschlag, dieselbe Rundung und dasselbe Zahlenformat an wie der Shop – **einschließlich Änderungen, die du
noch nicht gespeichert hast**. Eine Zeile, deren Kurs keinen Preis ergeben kann, zeigt stattdessen einen Strich.

## Zahlenformat pro Währung

*Seit 1.3.0.*

**Format bearbeiten** in einer Zeile öffnet fünf Felder nur für diese Währung:

| Feld | Funktion |
|---|---|
| **Symbol** | Das Symbol, das zusammen mit dem Betrag angezeigt wird |
| **Position** | Links, Rechts, Links mit Leerzeichen oder Rechts mit Leerzeichen |
| **Dezimalstellen** | Anzahl der Nachkommastellen, 0 bis 4 |
| **Dezimaltrennzeichen** | Ein Zeichen |
| **Tausendertrennzeichen** | Ein Zeichen |

WooCommerce speichert genau einen Satz dieser Werte für den gesamten Shop, weil es davon ausgeht, dass ein Shop
nur eine Währung hat. Diese Werte hier gelten pro Währung und nur für die jeweilige Währung.

Eingaben werden korrigiert statt stillschweigend übernommen – ein Trennzeichen mit mehr als einem Zeichen, eine
Anzahl an Dezimalstellen außerhalb von 0–4 oder ein Tausendertrennzeichen, das mit dem Dezimaltrennzeichen identisch ist. Wenn eine
Korrektur erfolgt, weist die Seite darauf hin, statt deine Eingabe kommentarlos zu ändern.

## Ist der Kurs aktuell?

*Seit 1.3.0.*

Jede Zeile hat eine Statuszeile, und der Tab-Kopf zeigt ein Zusammenfassungs-Badge:

| Zeile | Bedeutung |
|---|---|
| **manuell eingegeben** | Der Kurs ist ein **Manuell**-Wert; er stammt aus keiner Synchronisierung |
| **Noch kein Kurs – diese Währung wird im Shop nicht angezeigt** | Der Kurs ist 0 oder fehlt, daher lässt der Shop diese Währung weg |
| **Kurs gespeichert, keine Synchronisierung erfasst** | Es gibt einen Kurs, aber keinen Synchronisierungszeitstempel für diese Zeile |
| **vor N aktualisiert** | Eine Synchronisierung hat diesen Wert vor N erzeugt |

„Noch keine Synchronisierung erfasst“ bedeutet genau das – es gibt keinen Eintrag. Es wird nicht behauptet, dass nie eine Synchronisierung lief.
Das ist die ehrliche Lesart bei einem Shop, der von einer Version aktualisiert wurde, die keinen Zeitstempel gespeichert hat.

## Eine Währung hinzufügen

1. Klicke auf **+ Neue Währung**.
2. Wähle eine Währung aus dem Drop-down (die Basiswährung und bereits hinzugefügte Währungen sind ausgenommen).
3. Klicke auf **Hinzufügen**.
4. Lege Kurs, Aufschlag und Rundung fest.
5. Klicke auf **Änderungen speichern**.

Eine neu hinzugefügte Währung startet mit: aktiviert, Kurstyp **Automatisch**, Aufschlag **Keine**, Rundung **Keine**.

## Kurstypen

- **Automatisch** – das Kursfeld ist schreibgeschützt; sein Wert stammt aus einer Synchronisierung.
- **Manuell** – du gibst den Kurs selbst ein, mit bis zu 6 Nachkommastellen.

Eine Synchronisierung aktualisiert den Kurs jeder Währung unabhängig von ihrem Typ. Ein manuell eingegebener Kurs kann also bei der nächsten Synchronisierung überschrieben werden – prüfe ihn danach, wenn das für dich wichtig ist.

## Aufschläge

Es gibt drei Möglichkeiten, einen Aufschlag auf den Wechselkurs zu erheben:

| Typ | Wirkung | Beispiel (Kurs 0,92) |
|---|---|---|
| **Keine** | Kein Aufschlag | Effektiver Kurs 0,92 |
| **Prozent** | Der Kurs wird um einen Prozentsatz erhöht | 2,5 % → 0,92 × 1,025 = 0,943 |
| **Festbetrag** | Ein fester Betrag wird zum Kurs addiert | 0,03 → 0,92 + 0,03 = 0,95 |

## Rundung

Die Rundung erfolgt **nach** Anwendung von Kurs und Aufschlag und ist nicht auf Produktpreise beschränkt – seit 1.1.0 werden auch Versandkosten, Gebühren und Gutscheinrabatte auf dieselbe Weise gerundet.

| Typ | Wirkung |
|---|---|
| **Keine** | Keine Rundung |
| **Nächster Wert** | Rundet auf das nächstgelegene Vielfache der Schrittweite |
| **Aufrunden** | Rundet auf das nächsthöhere Vielfache der Schrittweite auf |
| **Abrunden** | Rundet auf das nächstniedrigere Vielfache der Schrittweite ab |

Wenn du etwas anderes als **Keine** wählst, erscheinen zwei zusätzliche Felder:

- **Step** – worauf gerundet wird (z. B. `1`, `5`, `0.5`)
- **Abzug** – ein Betrag, der nach dem Runden abgezogen wird, praktisch für Schwellenpreise

**Beispiel:** ein umgerechneter Preis von 47,30, Aufrunden, Schrittweite 1, Abzug 0,01 → **47,99**.

Eine Schrittweite von `0` deaktiviert die Rundung.

## Kurse synchronisieren

**Kurse synchronisieren** ruft sofort die aktuellen Kurse ab und schreibt sie in die Tabelle. Dafür braucht dein Server ausgehenden HTTP-Zugriff – offline funktioniert es nicht.

Die Kurse stammen in dieser Reihenfolge aus:

1. **ExchangeRate-API** (primär) – `api.exchangerate-api.com`
2. **Europäische Zentralbank** (Fallback) – der tägliche Referenz-Feed unter `www.ecb.europa.eu`

Beide sind kostenlos und benötigen keinen API-Schlüssel. Das Plugin probiert sie der Reihe nach aus und hört
beim ersten auf, der antwortet; antwortet keiner, bleiben deine bestehenden Kurse erhalten.
Abgerufene Kurse werden 1 Tag lang zwischengespeichert, und dieser Cache liefert die
Preisanzeige für Käufer. **Kurse synchronisieren** – egal ob du auf den Button klickst,
`wp mhmcs rates-sync` ausführst oder die geplante Aufgabe auslöst – umgeht immer den Cache
und fragt direkt die API ab.

*Geändert in 2.1.0.* Die Kette hatte früher zwei Fallbacks, zuerst Currency API und dann
Frankfurter, jetzt nur noch einen. Die Abdeckung ist unverändert – der EZB-Feed war bereits
die letzte Stufe der alten Kette, mit rund dreißig Währungen – nur die
Zwischenstufe entfällt. Wenn dein Shop ausgehende Anfragen auf eine Allow-List beschränkt, erlaube `www.ecb.europa.eu`.

Wenn du Serverzugriff hast, kannst du Kurse stattdessen auch über die Kommandozeile synchronisieren oder den Cache leeren – siehe [WP-CLI-Befehle](/docs/wp-cli).

Die vollständigen FAQ findest du auf der Seite [FAQ](/docs/faq); die vollständige Liste der bekannten Einschränkungen
auf der Seite [Bekannte Einschränkungen](/docs/known-limits).
