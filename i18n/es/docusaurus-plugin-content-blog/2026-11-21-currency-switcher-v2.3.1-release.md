---
slug: currency-switcher-v2.3.1-release
title: "Currency Switcher 2.3.1: alemán y español, y traducciones que llegan a todas las pantallas"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-21T09:40
---

La versión 2.3.1 añade las traducciones al alemán y al español y cambia la traducción que usa el plugin cuando hay más de una. No cambia nada más y no hay nada que configurar.

{/* truncate */}

## Alemán y español

El plugin ahora se distribuye en inglés, turco, alemán y español. En un sitio en alemán o en español, la pantalla de ajustes, las etiquetas del menú, los avisos de administración y el selector aparecen en ese idioma. Consulta [Idiomas](/docs/installation#idiomas).

## Las traducciones de WordPress.org llegan a la pantalla de ajustes

Las traducciones hechas en [translate.wordpress.org](https://translate.wordpress.org/projects/wp-plugins/mhm-currency-switcher/) llegan como paquete de idioma. Hasta ahora, la pantalla de ajustes ignoraba el paquete en los idiomas que incluye el plugin y mostraba siempre la traducción propia del plugin, así que una corrección hecha en translate.wordpress.org nunca llegaba a ella. Ahora el paquete de idioma tiene prioridad en todas las pantallas.

## El texto que falta recurre a la traducción del plugin

Un paquete de idioma puede ir por detrás de una nueva versión: el texto añadido en esa versión se muestra en inglés hasta que los traductores se ponen al día. Ahora ese texto usa la traducción propia del plugin y el paquete de idioma sigue prevaleciendo allí donde tiene el texto.

## WordPress 6.6 y 6.7

En WordPress 6.6 y 6.7, las etiquetas del menú, los avisos de administración y el selector se quedaban en inglés aunque el plugin incluyera una traducción para tu idioma. Ahora también se traducen ahí, así que el plugin se ve igual en todas las versiones compatibles.

[2.3.1 en GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.3.1)
