---
sidebar_position: 10
title: "Währungsumrechnung"
slug: /currency-conversion
---

# Währungsumrechnung

## Die Formel

```
Converted price = Base price × Effective rate   → rounding (if set)
```

Der effektive Kurs berücksichtigt die Gebührenart, die für eine Währung festgelegt ist:

| Gebührenart | Formel |
|---|---|
| Keine | Effektiver Kurs = Rohkurs |
| Prozentual | Effektiver Kurs = Rohkurs × (1 + Gebühr / 100) |
| Fest | Effektiver Kurs = Rohkurs + feste Gebühr |

**Beispiel** – Basiswährung TRY, Produktpreis 500:

| Währung | Rohkurs | Gebühr | Effektiver Kurs | Umgerechneter Preis |
|---|---|---|---|---|
| EUR | 0.0267 | 2.5% | 0.0274 | €13.68 |
| USD | 0.0293 | Keine | 0.0293 | $14.65 |
| GBP | 0.0230 | 0.002 fest | 0.0250 | £12.50 |

Wenn der Kurs einer Währung 0 ist oder die Währung nicht gefunden werden kann, wird der Preis nicht umgerechnet, anstatt als null angezeigt zu werden.

Die Rundung (Nächster Wert / Aufrunden / Abrunden, mit einer Schrittweite und einem optionalen Abzugsbetrag – siehe [Währungen verwalten](/docs/managing-currencies)) erfolgt **nach** der Anwendung von Kurs und Gebühr. Sie ist nicht auf Produktpreise beschränkt – seit 1.1.0 gilt sie auch für Versand- und Warenkorbgebühren sowie für Gutscheine mit festem Betrag.

## Was umgerechnet wird

| Feld | Verhalten |
|---|---|
| Produktpreis (regulär und Angebot) | Umgerechnet, gerundet |
| Variantenpreise und Preisspannen | Umgerechnet, gerundet |
| Warenkorb- und Bestellsummen | Aus den bereits umgerechneten Positionen berechnet |
| Warenkorbgebühren | Umgerechnet, gerundet |
| Versandkosten | Umgerechnet, gerundet |
| Steuer auf Versandkosten | Umgerechnet, **nicht gerundet** – sie folgt den Versandkosten |
| Gutscheine mit festem Betrag | Umgerechnet, gerundet |
| Mindest-/Höchstbestellwert für Gutscheine | Umgerechnet, **nicht gerundet** |

Prozentuale Gutscheine bleiben unverändert – ein Rabatt von 10 % beträgt unabhängig von der Währung 10 %.

Die beiden Zeilen mit „nicht gerundet“ sind Absicht und kein Versehen: Weder eine Steuerzeile für den Versand noch ein Bestellwert-Schwellenwert für Gutscheine ist ein Betrag, den der Kunde direkt bezahlt. Eine Rundung würde hier also eine Regel verändern (eine Steuerberechnung bzw. einen vom Händler festgelegten Schwellenwert), statt nur einen Preis auf dem Bildschirm zu glätten.

## Bestellungen

Die beim Checkout aktive Währung, der Kurs und die Basiswährung werden in der Bestellung gespeichert. Die Bestellansichten im Adminbereich und die Bestell-E-Mails zeigen immer den Betrag, den der Kunde tatsächlich bezahlt hat, in der Währung, in der er bezahlt hat – und Bestellungen, die aufgegeben wurden, bevor du das Plugin installiert hast oder bevor sich ein Preis geändert hat, werden niemals rückwirkend überschrieben.
