---
slug: currency-switcher-v2.3.0-release
title: "Currency Switcher 2.3.0: un selector accesible desde el teclado y precios convertidos que siguen al precio real"
authors: [maxhandmade]
tags: [release, currency-switcher]
date: 2026-11-04T02:30
---

La versión 2.3.0 hace que el selector de moneda se pueda usar desde el teclado, oculta los precios convertidos siempre que el precio propio de un producto esté oculto y carga menos en las páginas que no necesitan el selector. También eleva el mínimo de WooCommerce a la 9.1, así que comprueba tu versión de WooCommerce antes de actualizar.

{/* truncate */}

## WooCommerce 9.1 o posterior

El plugin decía que era compatible con WooCommerce 7.4, pero nada lo comprobaba. Ahora el mínimo indica la versión más antigua de WooCommerce que instalan realmente las pruebas automatizadas del plugin: **9.1**. Si tu tienda usa WooCommerce 7.4–9.0, actualiza primero WooCommerce. La lista completa de requisitos está en la [página de instalación](/docs/installation).

## El selector funciona desde el teclado

Podías llegar al selector con Tab y abrirlo con Intro, pero ninguna tecla permitía elegir una moneda. Ahora **Intro**, **Espacio**, **↓** o **↑** abren la lista en la moneda actual. **↑ ↓ Inicio Fin** te permiten desplazarte por ella, **Intro** o **Espacio** eligen una moneda y **Escape** cierra la lista sin cambiar nada. El foco del teclado se resalta con un contorno, también cuando el selector está en un menú de navegación, donde antes era invisible. Esto funciona igual en el shortcode, el widget de Elementor y el elemento de menú. Consulta [Opciones de visualización](/docs/display-options).

## Los precios convertidos se ocultan cuando el precio está oculto

Si un tema o un plugin ocultaba el precio de un producto (un modo catálogo o de mantenimiento, «inicia sesión para ver los precios»), el precio de WooCommerce desaparecía, pero los precios convertidos seguían mostrándose debajo. El widget de precio del producto ahora sigue al precio propio del producto. Cuando el precio se oculta o se sustituye por un mensaje, los precios convertidos también desaparecen. Cuando un plugin solo añade algo al precio, como una nota de «IVA incluido», se mantienen.

## Menos que cargar donde no se usa el selector

Cuando los precios se convierten en tu servidor (compatibilidad con caché desactivada, clientes con sesión iniciada, el carrito y la página de pago), el script del selector ahora solo se carga en las páginas que muestran un selector. Donde es el navegador el que convierte los precios (compatibilidad con caché activada, que es la opción predeterminada, para visitantes sin sesión iniciada, fuera del carrito y de la página de pago), no cambia nada.

[2.3.0 en GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.3.0)
