---
sidebar_position: 4
title: "Opciones de visualización"
slug: /display-options
---

# Opciones de visualización

**WooCommerce > MHM Currency > Opciones de visualización**

## Apariencia del selector

| Ajuste | Qué hace | Por defecto |
|---|---|---|
| **Mostrar icono de bandera** | Muestra la bandera de un país junto a la moneda | Activado |
| **Mostrar nombre de la moneda** | Muestra el nombre completo (p. ej., "US Dollar") | **Desactivado** |
| **Mostrar símbolo de la moneda** | Muestra el símbolo (p. ej., "$", "€") | Activado |
| **Mostrar código de la moneda** | Muestra el código ISO (p. ej., "USD", "EUR") | Activado |

La etiqueta se compone de las partes que estén activadas, en este orden: símbolo → código → nombre. Desactivar las cuatro no deja la etiqueta vacía: se muestra el código de la moneda como alternativa.

## Tamaño del selector

| Tamaño | Tamaño de fuente |
|---|---|
| Pequeño | 12px |
| Mediano (por defecto) | 14px |
| Grande | 16px |

## Uso con el teclado

El selector se puede usar sin ratón. Llega hasta él con la tecla Tab y pulsa **Intro**, **Espacio**, **↓** o **↑** para abrir la lista en la moneda actual. **↑ ↓ Inicio Fin** te desplazan por la lista, **Intro** o **Espacio** seleccionan una moneda y **Escape** cierra la lista sin cambiar nada. El foco del teclado se resalta con un contorno, también cuando el selector está en un menú de navegación.

## Widget de precio del producto

Una franja bajo el precio principal en las páginas de producto que muestra el precio convertido a varias monedas a la vez.

| Ajuste | Qué hace |
|---|---|
| **Activar el widget de precio del producto** | Activa o desactiva el widget |
| **Monedas que mostrar** | Elige hasta 5 monedas |
| **Mostrar banderas en el widget** | Muestra una bandera junto a cada precio |

Cuando está activado, aparece automáticamente dentro del resumen de precio del producto; no necesitas añadir un shortcode para ello. Permanece oculto si no hay ninguna moneda seleccionada. También se oculta siempre que lo esté el propio precio del producto: si un tema o plugin oculta los precios (un modo catálogo o de mantenimiento, "inicia sesión para ver los precios"), los precios convertidos se ocultan con él. Un plugin que solo añade algo al precio, como un sufijo "IVA incluido", no lo oculta.

**Ejemplo:**

```
Product price: $500.00

€459.20 | £395.10 | ¥75,300
```

Una vista previa en la parte inferior de la pestaña refleja tus ajustes actuales; es una representación simplificada y el aspecto real depende de tu tema.

## Cambio sin recargar la página

Cuando el modo de compatibilidad con caché está activado (la opción por defecto; consulta [Ajustes avanzados](/docs/advanced-settings)) y un visitante elige otra moneda en cualquier página que no sea la del carrito, la de pago o la de la cuenta, la página no se recarga: el plugin escribe la cookie, convierte los precios visibles en el sitio y actualiza el minicarrito. En la página del carrito, de pago o de la cuenta, en una página donde un tema o plugin define la constante del carrito de WooCommerce (consulta las [preguntas frecuentes](/docs/faq)), para un visitante con sesión iniciada o con la compatibilidad con caché desactivada, la página se recarga como antes.

Tienes todas las preguntas frecuentes en la página de [preguntas frecuentes](/docs/faq); la lista completa de limitaciones conocidas está
en la página de [Limitaciones conocidas](/docs/known-limits).
