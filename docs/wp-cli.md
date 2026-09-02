---
sidebar_position: 8
title: WP-CLI commands
---

# WP-CLI commands

If you manage the site from a terminal, five `wp mhmcs <subcommand>` commands cover everything the admin screen does for rates and status.

*Renamed in 2.1.0.* The command namespace was `wp mhm-cs` before this release. The hyphenated spelling is gone, so a script or cron entry still calling `wp mhm-cs rates-sync` now fails with an unknown-command error — drop the hyphen.

### Sync rates

```bash
wp mhmcs rates-sync
```

Fetches current rates for your base currency and writes only the ones that actually changed.

```
Fetching rates for base currency: TRY...
Success: Synced 3 exchange rates successfully.
```

### Look up one rate

```bash
wp mhmcs rates-get EUR
```

Shows the raw rate and the fee-adjusted effective rate for a single currency.

```
Currency:       EUR
Raw rate:       0.0267
Effective rate: 0.0274
Success: Rate retrieved for EUR.
```

### Flush the rate cache

```bash
wp mhmcs cache-flush
```

Clears the cached rates for your base currency, so the next sync fetches fresh values from the API instead of returning the cached ones.

### List currencies

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

### Check plugin status

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

The version line always reflects whatever you have installed — `1.2.0` above is just sample output, not a floor.

These five are the only `wp mhmcs` subcommands the plugin registers.
