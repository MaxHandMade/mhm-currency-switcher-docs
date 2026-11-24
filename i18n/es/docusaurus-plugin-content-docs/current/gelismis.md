---
sidebar_position: 5
title: "Ajustes avanzados"
slug: /advanced-settings
---

# Ajustes avanzados

**WooCommerce > MHM Currency > Avanzado**

Esta pestaña contiene cuatro ajustes.

## Detección por geolocalización

| Ajuste | Qué hace |
|---|---|
| **Activar la detección de moneda por geolocalización** | Detecta el país del visitante y muestra la moneda correspondiente |

La detección del país prueba dos fuentes, por orden, y **ninguna de ellas envía nada sobre el visitante fuera de tu servidor** (los tipos de cambio son otro asunto; consulta Actualizaciones automáticas de tipos más abajo):

1. **CloudFlare (principal)**: si tu sitio está detrás de CloudFlare, el código de país se lee de la cabecera `CF-IPCountry`. No necesita configuración y es rápido. Se ignoran los códigos de país desconocido y de nodos de salida de Tor.
2. **Base de datos local de MaxMind (alternativa)**: si no hay cabecera de CloudFlare, se consulta en su lugar el archivo de la base de datos GeoIP de MaxMind de WooCommerce, **almacenado en tu propio servidor**. Para ello necesitas una clave de licencia gratuita introducida en **WooCommerce > Ajustes > Integración > MaxMind Geolocation**.

**Si ninguna está disponible:** la detección no encuentra nada y el visitante ve la moneda base hasta que elija una por sí mismo. No se consulta a ningún tercero. La pestaña Avanzado lo indica directamente debajo del ajuste, tanto si está activado como desactivado.

> **Cambiado en la 2.2.0.** Las versiones anteriores llamaban a `geolocate_ip()` de WooCommerce con sus argumentos predeterminados. En una tienda sin base de datos de MaxMind, eso enviaba la dirección IP de cada nuevo visitante a un servicio remoto de geolocalización. La 2.2.0 elimina esa alternativa. Si dependías de la geolocalización sin CloudFlare ni una base de datos de MaxMind, ahora no encuentra nada: añade una clave de licencia gratuita de MaxMind para recuperarla. WooCommerce descarga el archivo de la base de datos desde MaxMind y lo actualiza periódicamente; esa petición lleva tu clave de licencia, nunca la dirección de un visitante, y todas las consultas posteriores se realizan en tu propio servidor.

**Configurar la base de datos de MaxMind (gratis):**

1. Crea una cuenta de MaxMind y completa el registro de **GeoLite2**.
2. Genera una clave de licencia en **Manage License Keys**.
3. Pega la clave en **WooCommerce > Ajustes > Integración > MaxMind Geolocation** y guarda.
4. WooCommerce descarga la base de datos en una carpeta `woocommerce_uploads/` dentro del directorio de subidas de tu sitio: en un sitio individual estándar es `wp-content/uploads/woocommerce_uploads/`; en un subsitio de una red multisitio, o cuando se ha personalizado la ubicación de las subidas, es el propio directorio de subidas de ese sitio. El nombre del archivo empieza con un prefijo impredecible a propósito, para que su dirección no se pueda adivinar desde fuera; no lo busques en la raíz del directorio de subidas.

**Cómo funciona:**

1. La detección solo se ejecuta cuando el visitante aún no tiene una cookie de moneda.
2. El código de país se asocia a una moneda.
3. Si esa moneda no está **activada** en tu tienda, la detección se considera fallida y se usa la moneda base.
4. Si la detección tiene éxito, se guarda una cookie para que la detección no vuelva a ejecutarse en las páginas siguientes.
5. Si el visitante elige otra moneda en el selector, esa elección se guarda en la cookie y, a partir de entonces, tiene prioridad sobre la geolocalización.

## Actualizaciones automáticas de tipos

Los tipos de cambio pueden actualizarse automáticamente mediante el sistema de tareas programadas de WordPress (WP-Cron).

| Opción | Efecto |
|---|---|
| **Solo manual** | Sin actualizaciones automáticas; se elimina la tarea programada |
| **Cada hora** | Se actualiza una vez por hora |
| **Dos veces al día** | Se actualiza dos veces al día |
| **Diariamente** | Se actualiza una vez al día |

Al cambiar el intervalo se borra la tarea programada existente y se vuelve a programar. Al desactivar el plugin se elimina la tarea por completo.

WP-Cron no es un cron real del sistema: solo se ejecuta cuando hay tráfico entrante. En un sitio con poco tráfico, configura el crontab de tu servidor para que apunte a `wp-cron.php` y así las actualizaciones sigan ejecutándose según lo programado.

Las fuentes de tipos de cambio no necesitan clave de API, por lo que esta pestaña no tiene selector de proveedor ni campo de clave.

## Modo de compatibilidad con caché

*Desde la 1.1.0.*

Una caché de páginas guarda el HTML que tu servidor generó para quien lo pidió primero. Cuando los precios se convierten en el servidor, eso significa que la moneda del primer visitante es la que se sirve a todos los visitantes posteriores.

El **modo de compatibilidad con caché**, activado de forma predeterminada, lo evita: para los visitantes no conectados, todas las páginas públicas excepto las del carrito, el pago y la cuenta (incluidas las de la tienda, las categorías y los productos) se generan siempre en tu **moneda base**, de modo que la misma página en caché es correcta para todos. Después, el navegador convierte los precios mostrados, una vez cargada la página, mediante una petición a este plugin. Si un tema o un plugin define la constante del carrito de WooCommerce en todas las páginas, esto deja de aplicarse: el plugin te avisa en la administración; consulta las [preguntas frecuentes](/docs/faq).

Esta separación es intencionada: solo los precios *mostrados* se convierten en el navegador. El carrito, el pago, los totales de los pedidos, los correos electrónicos de los pedidos y la API REST de WooCommerce se calculan siempre en el servidor, en la moneda que el cliente eligió realmente, de modo que el importe cobrado no puede alterarse desde el navegador.

| Ajuste | Qué hace |
|---|---|
| **Guardar en caché las páginas en la moneda base** | Si lo desactivas, los precios vuelven a convertirse en el servidor, como antes de la 1.1.0, lo que no funciona bien con un plugin de caché de páginas. Los totales del carrito, el pago y los pedidos se convierten siempre en el servidor en cualquier caso. |

Desactivar el modo no restaura exactamente el comportamiento de la 1.0.0: las correcciones de la administración, la API REST y las tareas programadas siguen activas en ambos modos.

## Qué ocurre al eliminar el plugin

*Desde la 1.3.0.*

| Ajuste | Qué hace |
|---|---|
| **Borrar todos los datos al eliminar el plugin** | Desactivado de forma predeterminada. Si lo dejas desactivado, tus ajustes y la moneda y el tipo de cambio registrados en cada pedido se conservan al borrar el plugin. |

Esos registros por pedido son la única base del historial de ventas multimoneda y no se pueden
reconstruir después, por eso la opción destructiva es la que tienes que elegir
conscientemente y no la que ocurre de forma predeterminada. Desactivar el plugin nunca borra
nada; solo lo hace borrarlo, y únicamente con este interruptor activado.

En una red multisitio, el interruptor borra los datos del sitio del que se elimina el plugin.

Las preguntas frecuentes completas están en la página de [preguntas frecuentes](/docs/faq); la lista completa de limitaciones conocidas está
en la página de [limitaciones conocidas](/docs/known-limits).
