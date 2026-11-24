---
slug: currency-switcher-v2.2.0-release
title: "Currency Switcher 2.2.0: las direcciones IP de los visitantes ya no salen de tu servidor"
authors: [maxhandmade]
tags: [release, currency-switcher, privacy, geolocation]
date: 2026-09-07T13:25
---

2.2.0 es una corrección de privacidad. En una tienda sin una base de datos local de MaxMind, la geolocalización podía enviar la dirección IP de cada nuevo visitante a un servicio remoto de geolocalización. Ya no puede hacerlo. Además, la geolocalización está desactivada por defecto en las instalaciones nuevas. Si dependes de ella, lee la última sección: en algunas tiendas ahora necesita un ajuste para seguir funcionando.

{/* truncate */}

## Qué ha cambiado

Para detectar la moneda de un visitante, el plugin pregunta a WooCommerce en qué país se encuentra el visitante. Cuando WooCommerce no tenía una base de datos local de MaxMind, esa consulta podía recurrir a un servicio remoto de geolocalización, que recibía la dirección IP del visitante. El propio código de la tienda de WooCommerce desactiva ese recurso alternativo; este plugin llamaba a la misma función con sus valores por defecto, así que para esta funcionalidad el recurso alternativo seguía activado. 2.2.0 también lo desactiva. Ahora la detección usa solo la cabecera de país de CloudFlare o una base de datos de MaxMind en tu propio servidor: **ningún dato del visitante sale de tu servidor**.

## La geolocalización empieza desactivada en las instalaciones nuevas

Determinar el país de un visitante a partir de su dirección IP es un tratamiento de datos, así que en una instalación nueva ahora es algo que activas de forma deliberada, en la pestaña **Avanzado**. **Las tiendas que se actualizan mantienen el ajuste que ya tenían**: no se desactiva nada por ti.

## ⚠️ Si usas la geolocalización sin CloudFlare ni MaxMind

Ahora la detección no encontrará nada en lugar de consultar un servicio remoto, y los visitantes verán tu moneda base hasta que elijan una. Para mantener la funcionalidad, añade una clave de licencia gratuita de MaxMind GeoLite2 en **WooCommerce > Ajustes > Integración > MaxMind Geolocation**. WooCommerce descargará entonces la base de datos y la mantendrá actualizada, y todas las consultas se harán en tu propio servidor. La pestaña Avanzado ahora indica qué necesita la geolocalización, tanto si está activada como si no. Más detalles: [Ajustes avanzados](/docs/advanced-settings) y [Detección de moneda](/docs/currency-detection).

[2.2.0 en GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.2.0)
