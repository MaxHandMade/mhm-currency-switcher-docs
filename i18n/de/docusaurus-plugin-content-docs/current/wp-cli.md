---
sidebar_position: 8
title: "WP-CLI-Befehle"
---

# WP-CLI-Befehle

Wenn du die Website über ein Terminal verwaltest, decken fünf `wp mhmcs <subcommand>`-Befehle alles ab, was der Admin-Bildschirm für Kurse und Status erledigt.

*In 2.1.0 umbenannt.* Vor diesem Release lautete der Befehls-Namespace `wp mhm-cs`. Die Schreibweise mit Bindestrich gibt es nicht mehr. Ein Skript oder Cron-Eintrag, der noch `wp mhm-cs rates-sync` aufruft, schlägt daher jetzt mit einem Fehler wegen eines unbekannten Befehls fehl – entferne den Bindestrich.

### Kurse synchronisieren

```bash
wp mhmcs rates-sync
```

Ruft die aktuellen Kurse für deine Basiswährung ab und schreibt nur diejenigen, die sich tatsächlich geändert haben.

```
Fetching rates for base currency: TRY...
Success: Synced 3 exchange rates successfully.
```

### Einen einzelnen Kurs abfragen

```bash
wp mhmcs rates-get EUR
```

Zeigt den Rohkurs und den um Gebühren bereinigten effektiven Kurs für eine einzelne Währung an.

```
Currency:       EUR
Raw rate:       0.0267
Effective rate: 0.0274
Success: Rate retrieved for EUR.
```

### Den Kurs-Cache leeren

```bash
wp mhmcs cache-flush
```

Löscht die zwischengespeicherten Kurse für deine Basiswährung, sodass die nächste Synchronisierung frische Werte von der API abruft, statt die zwischengespeicherten zurückzugeben.

### Währungen auflisten

```bash
wp mhmcs currencies-list
```

```
Base currency: TRY

+------+--------+---------+--------+
| Code | Rate   | Enabled | Symbol |
+------+--------+---------+--------+
| EUR  | 0.0267 | Yes     | €      |
| USD  | 0.0293 | Yes     | $      |
| GBP  | 0.0230 | Yes     | £      |
+------+--------+---------+--------+
```

### Plugin-Status prüfen

```bash
wp mhmcs status
```

```
MHM Currency Switcher v1.2.0
Base currency:      TRY
Total currencies:   3
Enabled currencies: 3
Success: Status check complete.
```

Die Versionszeile gibt immer wieder, was du installiert hast – `1.2.0` oben ist nur eine Beispielausgabe, keine Mindestversion.

Diese fünf sind die einzigen `wp mhmcs`-Unterbefehle, die das Plugin registriert.
