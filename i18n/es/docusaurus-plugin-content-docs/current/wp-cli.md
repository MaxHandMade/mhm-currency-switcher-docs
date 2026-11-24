---
sidebar_position: 8
title: "Comandos de WP-CLI"
---

# Comandos de WP-CLI

Si gestionas el sitio desde un terminal, cinco comandos `wp mhmcs <subcommand>` cubren todo lo que hace la pantalla de administración en cuanto a tipos de cambio y estado.

*Renombrado en la 2.1.0.* El espacio de nombres de los comandos era `wp mhm-cs` antes de esta versión. La grafía con guion ha desaparecido, así que un script o una entrada de cron que siga llamando a `wp mhm-cs rates-sync` ahora falla con un error de comando desconocido: elimina el guion.

### Sincronizar tipos de cambio

```bash
wp mhmcs rates-sync
```

Obtiene los tipos de cambio actuales de tu moneda base y guarda solo los que realmente han cambiado.

```
Fetching rates for base currency: TRY...
Success: Synced 3 exchange rates successfully.
```

### Consultar un tipo de cambio

```bash
wp mhmcs rates-get EUR
```

Muestra el tipo de cambio sin procesar y el tipo efectivo ajustado con comisiones para una sola moneda.

```
Currency:       EUR
Raw rate:       0.0267
Effective rate: 0.0274
Success: Rate retrieved for EUR.
```

### Vaciar la caché de tipos de cambio

```bash
wp mhmcs cache-flush
```

Borra los tipos de cambio almacenados en caché de tu moneda base, de modo que la siguiente sincronización obtenga valores nuevos de la API en lugar de devolver los almacenados en caché.

### Listar monedas

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

### Comprobar el estado del plugin

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

La línea de versión siempre refleja lo que tengas instalado: `1.2.0` arriba es solo una salida de ejemplo, no una versión mínima.

Estos cinco son los únicos subcomandos de `wp mhmcs` que registra el plugin.
