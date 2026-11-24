---
sidebar_position: 12
title: "Referencia de la API REST"
---

# Referencia de la API REST

**Espacio de nombres:** `mhmcs/v1` · **URL base:** `/wp-json/mhmcs/v1/`

La mayoría de los sitios nunca llaman a estos endpoints directamente: el selector, el widget de producto y el modo de compatibilidad con caché los usan automáticamente. Están documentados aquí para quien esté desarrollando una integración o depurando una configuración de caché.

## Endpoints públicos

### GET `/rates` — eliminado

*Eliminado en la 2.1.0.* El endpoint público y sin autenticación `/mhmcs/v1/rates` ya no existe y no tiene sustituto: duplicaba información que la página ya muestra en sus precios. Las rutas autenticadas `/rates/sync` y `/rates/preview` que usa la pantalla de ajustes no se ven afectadas.

### POST `/convert`

*Desde la 1.1.0.* Esto es lo que llama el navegador, automáticamente, cuando el [modo de compatibilidad con caché](/docs/advanced-settings) está activado: solicita los precios reales de los productos marcados en una página que, por lo demás, está en caché en la moneda base. Envía `product_ids` (hasta 50 por solicitud; el servidor aplica el límite independientemente de lo que envíes) y, opcionalmente, un `currency`; omítelo para que el servidor [detecte](/docs/currency-detection) la moneda del visitante por ti. La respuesta devuelve qué moneda se ha usado y el HTML con el precio de cada ID:

```json
{
    "currency": "EUR",
    "detected": false,
    "prices": { "101": "<span class=\"woocommerce-Price-amount amount\">€13,68</span>" }
}
```

`detected` es `true` solo cuando el propio servidor ha resuelto la moneda (la geolocalización ha funcionado y no se ha enviado `currency` en la solicitud); es `false` para un `currency` explícito, y `false` cuando la detección tampoco ha dado resultado. Es importante porque la escritura de la cookie por parte del propio navegador depende de ello: `price-converter.js` solo guarda la cookie cuando `detected: true`, de modo que una detección fallida no queda fijada en la moneda base y la geolocalización se vuelve a intentar en la siguiente página que visite el visitante.

No requiere autenticación por diseño (las páginas que sirve las leen visitantes sin sesión iniciada que no tienen ningún nonce que enviar), pero su alcance está muy limitado: solo HTML de productos que ya es público, no escribe nada en el servidor y tiene un límite de frecuencia por dirección de **120 solicitudes por minuto**, ajustable mediante el filtro `mhmcs_convert_rate_limit`. Si se supera, devuelve `429` con una cabecera `Retry-After`. Para una explicación completa de por qué funciona así, consulta la pregunta [«¿Hay un límite en la frecuencia con la que se puede llamar al endpoint de conversión?»](/docs/faq) de nuestras preguntas frecuentes.

## Endpoints de administración

> Todos ellos requieren la capacidad `manage_woocommerce`. La propia pantalla de ajustes es un cliente de estas mismas rutas.

| Método | Endpoint | Qué hace |
|---|---|---|
| GET | `/settings` | Obtiene los ajustes del plugin |
| POST | `/settings` | Guarda los ajustes del plugin |
| GET | `/currencies` | Obtiene la moneda base y las monedas configuradas |
| POST | `/currencies` | Guarda las monedas |
| POST | `/rates/sync` | Obtiene y actualiza los tipos de cambio desde la fuente |
| GET | `/rates/preview` | Tipo de cambio bruto y efectivo por moneda |
| POST | `/rates/preview` | Lo mismo, para una configuración enviada (sin guardar); no guarda nada |
| POST | `/cache-notice/snooze-anomaly` | Pospone el aviso de administración de anomalía de caché *(2.1.0)* |
| POST | `/cache-notice/snooze-fragments` | Pospone el aviso de administración de fragmentos de caché *(2.1.0)* |

## Moneda en la API de productos de WooCommerce

Añade un parámetro `currency` a los propios endpoints de productos de WooCommerce para obtener los precios convertidos:

```bash
curl https://yourstore.com/wp-json/wc/v3/products?currency=EUR
```

`price`, `regular_price` y `sale_price` se devuelven convertidos, y se añade un campo `currency_code`. Si omites el parámetro, o envías una moneda que tu tienda no ofrece, la respuesta queda fijada en tu moneda base, de modo que el resultado depende únicamente de la solicitud, nunca de las cookies de quien la hace.

Las preguntas frecuentes completas están en la página de [preguntas frecuentes](/docs/faq); la lista completa de limitaciones conocidas está
en la página de [limitaciones conocidas](/docs/known-limits).
