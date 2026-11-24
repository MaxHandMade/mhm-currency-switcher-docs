---
slug: currency-switcher-v2.1.0-release
title: "Currency Switcher 2.1.0: en WordPress.org y con un único prefijo en todas partes"
authors: [maxhandmade]
tags: [release, currency-switcher, css, rest-api]
date: 2026-08-30T15:27
---

MHM Currency Switcher ya está disponible en WordPress.org, y la 2.1.0 es la versión con la que llegó: a partir de ahora WordPress te ofrece sus actualizaciones como las de cualquier otro plugin. Esta versión también completa una limpieza de nombres que cambia tres cosas en las que puede apoyarse el código personalizado, así que, si has escrito CSS, JavaScript o PHP para el plugin, lee la primera sección antes de actualizar.

{/* truncate */}

## Antes de actualizar: tres cosas han cambiado de nombre o de forma

**Clases CSS.** Todas las clases que usa el selector han cambiado su prefijo de `mhm-cs-` a `mhmcs-`: `.mhm-cs-switcher` ahora es `.mhmcs-switcher`, `.mhm-cs-dropdown` ahora es `.mhmcs-dropdown`, y así con todas las clases. No se mantiene ningún alias para los nombres antiguos, por lo que el CSS o JavaScript personalizado escrito para ellos deja de coincidir en cuanto actualices. La lista completa está en la página [Clases CSS](/docs/css).

**El respaldo de tipos de cambio.** Cuando no se puede acceder a la fuente principal de tipos de cambio, el plugin ahora hace una única petición al feed diario de referencia del Banco Central Europeo. La cadena de dos etapas añadida en la 2.0.0 (primero Currency API y después Frankfurter) desaparece. La cobertura no cambia, unas treinta monedas, porque el BCE ya era el último paso de la cadena anterior. Si tu código filtra la dirección de respaldo, el argumento `$source` del filtro `mhmcs_fallback_rates_url` ahora es siempre `ecb`. Consulta [Gestionar monedas](/docs/managing-currencies).

**El endpoint público de tipos de cambio.** Se ha eliminado la ruta REST `GET /mhmcs/v1/rates` sin autenticación; repetía lo que la página ya muestra en sus precios. Las rutas autenticadas que usa la pantalla de ajustes no se ven afectadas. Consulta la [referencia de la API REST](/docs/rest-api).

## Avisos más discretos y en el lugar adecuado

- Los dos avisos de compatibilidad con la caché se pueden posponer. Posponer un aviso solo lo descarta para el problema detectado en ese momento: si más adelante aparece un problema de caché nuevo y distinto, el aviso vuelve en lugar de quedarse en silencio para siempre. *Más tarde: en la 2.2.1, un aviso pospuesto se mantiene así hasta que el aviso se resuelve; consulta las [notas de la 2.2.1](/blog/currency-switcher-v2.2.1-release).*
- El aviso de que falta WooCommerce y los dos avisos de caché ahora aparecen solo en las pantallas que les corresponden, en lugar de en todas las pantallas de administración, y solo a quienes pueden actuar sobre ellos: los usuarios que pueden activar plugins en el primer caso y los usuarios que pueden gestionar WooCommerce en los otros dos.

## También en esta versión

- Se ha eliminado la migración de ajustes para las instalaciones que nunca se actualizaron más allá de la versión de 2026-03, junto con las ramas correspondientes de opciones antiguas en la rutina de desinstalación. Ninguna versión publicada desde la 1.0.0 (2026-07) se ve afectada.
- Los últimos nombres `mhm-cs-`, `mhm_cs_` y `mhm_currency_switcher_` que quedaban en el plugin se han renombrado con el prefijo `mhmcs`.
- El paquete de la versión ya no incluye los archivos de traducción compilados. *Más tarde: la 2.2.1 vuelve a incluir la traducción al turco en el plugin; consulta las [notas de la 2.2.1](/blog/currency-switcher-v2.2.1-release).*

[2.1.0 en GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.1.0)
