---
sidebar_position: 2
title: "Instalación"
slug: /installation
---

# Instalación y requisitos

## Requisitos

| Requisito | Versión mínima |
|---|---|
| WordPress | 6.6 |
| PHP | 7.4 |
| WooCommerce | 9.1 |

Esta es la única página de este sitio que indica estos mínimos: consúltalos aquí y no en otro lugar.

## Instalar el plugin

1. Sube la carpeta `mhm-currency-switcher` a `/wp-content/plugins/` o instálalo directamente desde la pantalla de plugins de WordPress.
2. Actívalo desde el menú **Plugins**.
3. Asegúrate de que WooCommerce esté instalado y activo: el plugin no hace nada sin él y muestra un aviso en la administración indicándolo.
4. Ve a **WooCommerce > MHM Currency**.

Necesitas la capacidad `manage_woocommerce` para ver la pantalla de ajustes (los perfiles Gestor de la tienda y Administrador la tienen por defecto).

## Qué obtienes justo después de la activación

- **La lista de monedas empieza vacía.** No hay monedas añadidas de antemano; añades las que quieras.
- La detección por geolocalización empieza **desactivada** (desde la 2.2.0). Averiguar el país de un visitante a partir de su dirección IP es un tratamiento de datos, así que se deja para que la actives tú de forma deliberada. Las tiendas que actualizan conservan lo que ya hubieran elegido.
- La apariencia del selector empieza con estos valores por defecto: bandera **activada**, símbolo **activado**, código **activado**, nombre de la moneda **desactivado**, tamaño **Medio**.
- El modo de compatibilidad con la caché empieza **activado**: consulta [Ajustes avanzados](/docs/advanced-settings) para ver qué hace.

La moneda base de tu tienda siempre procede de los ajustes de WooCommerce (**WooCommerce > Ajustes > Generales > Opciones de moneda**). No puedes añadir la moneda base a la lista de monedas del plugin: ya es el punto de partida de la conversión.

## Las cuatro pestañas de ajustes

| Pestaña | Qué contiene |
|---|---|
| **Gestionar monedas** | La lista de monedas: tipo de cambio, comisión, redondeo, orden |
| **Opciones de visualización** | La apariencia del selector y el widget de precio del producto |
| **Avanzado** | Geolocalización, la programación de la actualización automática de tipos de cambio y la compatibilidad con la caché |
| **Cómo se usa** | Fragmentos para copiar para cada lugar de tu sitio donde se puede colocar el selector |

Los cambios sin guardar muestran una barra en la parte superior de la pantalla. **Guardar cambios** aparece tanto en esa barra como al final de la página, y guarda las cuatro pestañas en una sola petición.

## Idiomas

El plugin incluye inglés, turco, alemán y español, y en un sitio en uno de estos idiomas todo el plugin aparece en ese idioma en todas las versiones de WordPress compatibles (6.6 y posteriores). Cuando WordPress.org tiene un paquete de idioma para tu idioma, el paquete tiene prioridad, y la traducción propia del plugin completa cualquier texto que el paquete aún no tenga. Las traducciones a otros idiomas se hacen en [translate.wordpress.org](https://translate.wordpress.org/projects/wp-plugins/mhm-currency-switcher/), donde cualquiera con una cuenta de WordPress.org puede colaborar.

Las preguntas frecuentes completas están en la página [Preguntas frecuentes](/docs/faq); la lista completa de limitaciones conocidas está
en la página [Limitaciones conocidas](/docs/known-limits).
