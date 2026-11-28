---
slug: currency-switcher-v2.3.2-release
title: "Currency Switcher 2.3.2: encabezados de columna más limpios, probado con WooCommerce 11.3"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-28T12:00
---

La versión 2.3.2 es una pequeña versión de mantenimiento. Los encabezados de columna largos de la pestaña Gestionar monedas ahora se dividen entre sílabas, y el plugin está probado con WooCommerce 11.3. No hay nada que configurar.

{/* truncate */}

## Los encabezados se dividen entre sílabas

Cuando un encabezado de columna de la pestaña **Gestionar monedas** no cabe en su columna, pasa a una segunda línea. Hasta ahora se cortaba en la letra que llegaba al borde: por ejemplo, el alemán «Reihenfolge» (Orden) quedaba como «Reihenf / olge». Ahora se divide entre sílabas y añade un guion: «Reihen- / folge». En español, «Activado» se divide como «Acti- / vado». Los encabezados en inglés y en turco siguen cabiendo en una línea.

## Probado con WooCommerce 11.3

Las pruebas automáticas se ejecutaron con WooCommerce 11.3.1 sobre WordPress 7.1.5, con y sin HPOS, y pasaron. La cabecera «WC tested up to» del plugin ahora indica 11.3.

[2.3.2 en GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.3.2)
