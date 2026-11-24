---
sidebar_position: 9
title: "Detección de la moneda"
slug: /currency-detection
---

# Detección de la moneda

Todos los puntos del sitio donde se muestran precios —el renderizado de las páginas, el carrito, el endpoint de conversión— determinan la moneda del visitante mediante la misma cadena de cuatro pasos, en este orden:

1. **Cookie**: máxima prioridad.
2. **Parámetro de URL** (`?currency=EUR`).
3. **Geolocalización**: solo cuando está activada en [Ajustes avanzados](/docs/advanced-settings).
4. **Moneda base**: la opción de respaldo.

Cualquier código encontrado en un paso se descarta (y la cadena pasa al siguiente) a menos que sea la moneda base de la tienda o una moneda que hayas activado. Existe una única implementación de esta regla, compartida por todos los que la invocan: ninguna página ni endpoint tiene su propia copia que pueda desviarse de ella sin que nadie lo note.

## Cookie

Hay **tres** lugares distintos en los que se escribe esta cookie; si un visitante se queda atascado en la moneda equivocada, la solución depende de cuál de ellos esté implicado:

1. **Selección en el selector.** Cuando un visitante elige una moneda en el desplegable, el navegador (`switcher.js`) escribe la cookie directamente.
2. **Geolocalización, en el servidor.** `detect_from_geolocation()` pone en cola lo que encuentre y `prime_currency_cookie()` —enganchado en `template_redirect`, prioridad 0— lo escribe en la cookie, **salvo que el renderizado actual sea uno que una caché de página vaya a almacenar.** En un renderizado cacheable (modo de compatibilidad con caché activado, visitante sin sesión iniciada, cualquier página del front-end que no sea la del carrito, la de pago o la de la cuenta, y que no sea una página en la que un tema o plugin defina la constante del carrito de WooCommerce; consulta las [preguntas frecuentes](/docs/faq)) esta escritura se omite a propósito: escribirla ahí guardaría en el HTML en caché la moneda geolocalizada de un visitante y se la serviría a todos los que carguen esa página después.
3. **Geolocalización, en el cliente.** Justo en los renderizados cacheables en los que el paso 2 se abstiene, el navegador llama por sí mismo al [endpoint de conversión](/docs/rest-api); si la respuesta devuelve `detected: true`, `price-converter.js` escribe la cookie en su lugar. Los pasos 2 y 3 son complementarios, no se solapan: en cualquier renderizado, solo se ejecuta uno de ellos.

Los tres escriben los mismos atributos (30 días, `path=/`, `SameSite=Lax`, `Secure` solo en HTTPS), que se mantienen sincronizados a propósito entre dos scripts distintos y la parte de PHP, porque basta con que un atributo no coincida para que la elección de un visitante deje de conservarse, sin aviso, en un modo pero no en los demás.

| Propiedad | Valor |
|---|---|
| Nombre | `mhmcs_currency` |
| Duración | 30 días |
| Ruta | `/` (todo el sitio) |
| Secure | Sí, en sitios HTTPS |
| SameSite | Lax |
| HttpOnly | No |

## Parámetro de URL

Añadir `?currency=EUR` a un enlace selecciona una moneda para esa vista de página:

```
https://yourstore.com/product-page/?currency=EUR
https://yourstore.com/shop/?currency=USD
```

Resulta útil para enlaces de campañas. Es de **solo lectura** para esa petición: a propósito no escribe ninguna cookie, de modo que en la siguiente carga de página el visitante vuelve a lo que indique la cookie (o la geolocalización), no el parámetro. Si ya hay una cookie establecida, el parámetro no tiene ningún efecto, ya que la cookie se comprueba primero. Usa el propio selector si quieres que una elección se mantenga.

## Geolocalización

Solo se ejecuta cuando está activada y únicamente cuando todavía no hay cookie. Consulta [Ajustes avanzados](/docs/advanced-settings) para ver el orden de consulta de CloudFlare/MaxMind y qué ocurre cuando no se puede determinar el país.

## Moneda base

La opción de respaldo cuando ninguno de los pasos anteriores ha dado una moneda válida: la que tengas configurada como moneda base en WooCommerce.

## Una excepción: el endpoint de conversión

La petición [`POST /convert`](/docs/rest-api) que hace el navegador en el modo de compatibilidad con caché pasa por esta misma cadena, pero con la escritura de la cookie y la geolocalización desactivadas para esa petición concreta: en ese modo, la cookie la gestiona el navegador, y una escritura desde el servidor entraría en conflicto con ella.
