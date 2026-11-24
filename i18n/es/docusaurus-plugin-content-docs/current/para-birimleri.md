---
sidebar_position: 3
title: "Gestionar monedas"
slug: /managing-currencies
---

# Gestionar monedas

**WooCommerce > MHM Currency > Gestionar monedas**

Aquí es donde configuras qué monedas ofrece tu tienda.

## La tabla de monedas

| Columna | Qué hace |
|---|---|
| **Activado** | Activa o desactiva una moneda. Las monedas desactivadas no aparecen en el selector. |
| **Código** | El código ISO 4217, la bandera y el nombre completo de la moneda. |
| **Tipo de cambio** | Tipo de tasa (Automático / Manual) y el valor del tipo de cambio. |
| **Recargo** | Un recargo adicional sobre el tipo de cambio (Ninguno / Porcentaje / Fijo). |
| **Redondeo** | La regla de redondeo aplicada al importe convertido. |
| **Orden** | Flechas arriba/abajo para reordenar el desplegable del selector. |
| **Acciones** | Elimina la moneda de la lista. |

La moneda base **no** es una fila de esta tabla: se indica encima de la tabla y procede de
**WooCommerce > Ajustes > Generales**. En la tienda es la primera entrada del selector.

## Lo que verá el cliente

*Desde la versión 1.3.0.*

Debajo de cada fila hay una línea de vista previa: `Customer sees: 100.00 <base> → …`. Se calcula en el
servidor con el propio formateador de precios de la tienda, no se estima en el navegador, así que aplica el mismo
tipo de cambio, recargo, redondeo y formato numérico que aplicará la tienda, **incluidos los cambios que aún no
has guardado**. Una fila cuyo tipo de cambio no puede generar un precio muestra un guion en su lugar.

## Formato numérico por moneda

*Desde la versión 1.3.0.*

**Editar formato** en una fila abre cinco campos solo para esa moneda:

| Campo | Qué hace |
|---|---|
| **Símbolo** | El símbolo que se muestra junto al importe |
| **Posición** | Izquierda, Derecha, Izquierda con espacio o Derecha con espacio |
| **Decimales** | Cuántas posiciones decimales, de 0 a 4 |
| **Separador decimal** | Un carácter |
| **Separador de miles** | Un carácter |

WooCommerce guarda exactamente un conjunto de estos valores para toda la tienda, porque da por hecho que una tienda tiene
una sola moneda. Estos valores son por moneda y se aplican solo a esa moneda.

Las entradas se corrigen en lugar de aceptarse sin más: un separador de más de un carácter, un
número de decimales fuera del rango 0–4 o un separador de miles idéntico al separador decimal. Cuando se produce una
corrección, la pantalla lo indica, en lugar de cambiar lo que has introducido sin avisar.

## ¿Está actualizado el tipo de cambio?

*Desde la versión 1.3.0.*

Cada fila lleva una línea de estado y la cabecera de la pestaña muestra una etiqueta de resumen:

| Línea | Significado |
|---|---|
| **introducido manualmente** | El tipo de cambio es un valor **Manual**; no lo ha generado ninguna sincronización |
| **Aún no hay tipo de cambio: esta moneda no se muestra en la tienda** | El tipo de cambio es 0 o falta, así que la tienda excluye esta moneda |
| **tipo de cambio guardado, sin sincronización registrada** | Hay un tipo de cambio, pero no hay marca de tiempo de sincronización para esta fila |
| **actualizado hace N** | Una sincronización generó este valor hace N |

«Aún no se ha registrado ninguna sincronización» significa exactamente eso: que no hay registro. No afirma que nunca se haya ejecutado una sincronización,
que es la interpretación honesta en una tienda que se actualiza desde una versión que no guardaba marcas de tiempo.

## Añadir una moneda

1. Haz clic en **+ Nueva moneda**.
2. Elige una moneda del desplegable (se excluyen la moneda base y las que ya has añadido).
3. Haz clic en **Añadir**.
4. Configura su tipo de cambio, recargo y redondeo.
5. Haz clic en **Guardar cambios**.

Una moneda recién añadida empieza así: activada, tipo de tasa **Automático**, recargo **Ninguno**, redondeo **Ninguno**.

## Tipos de tasa

- **Automático**: el campo del tipo de cambio es de solo lectura; su valor procede de una sincronización.
- **Manual**: escribes tú mismo el tipo de cambio, con hasta 6 decimales.

La sincronización actualiza el tipo de cambio de todas las monedas, sea cual sea su tipo, así que un tipo de cambio introducido manualmente puede sobrescribirse en la siguiente sincronización; compruébalo después si es importante para ti.

## Recargos

Tres formas de añadir un margen sobre el tipo de cambio:

| Tipo | Efecto | Ejemplo (tipo de cambio 0,92) |
|---|---|---|
| **Ninguno** | Sin recargo | Tipo de cambio efectivo 0,92 |
| **Porcentaje** | El tipo de cambio se incrementa en un porcentaje | 2,5 % → 0,92 × 1,025 = 0,943 |
| **Fijo** | Se suma una cantidad fija al tipo de cambio | 0,03 → 0,92 + 0,03 = 0,95 |

## Redondeo

El redondeo se aplica **después** del tipo de cambio y del recargo, y no se limita a los precios de los productos: desde la versión 1.1.0 también redondea del mismo modo los envíos, los cargos y los descuentos de cupones.

| Tipo | Efecto |
|---|---|
| **Ninguno** | Sin redondeo |
| **Más cercano** | Redondea al múltiplo del paso más cercano |
| **Redondear hacia arriba** | Redondea hacia arriba al siguiente múltiplo del paso |
| **Redondear hacia abajo** | Redondea hacia abajo al múltiplo anterior del paso |

Si eliges cualquier opción distinta de **Ninguno**, se abren dos campos adicionales:

- **Paso**: a qué redondear (p. ej., `1`, `5`, `0.5`)
- **Restar**: una cantidad que se descuenta después de redondear, útil para precios psicológicos

**Ejemplo:** un precio convertido de 47,30, Redondear hacia arriba, paso 1, restar 0,01 → **47,99**.

Un paso de `0` desactiva el redondeo.

## Sincronizar tipos de cambio

**Sincronizar tipos de cambio** obtiene al instante los tipos de cambio actuales y los escribe en la tabla. Necesita que tu servidor tenga acceso HTTP saliente: no funciona sin conexión.

Los tipos de cambio proceden, por orden, de:

1. **ExchangeRate-API** (principal): `api.exchangerate-api.com`
2. **Banco Central Europeo** (alternativa): el feed de referencia diario en `www.ecb.europa.eu`

Ambos son gratuitos y no necesitan clave de API. El plugin los prueba por orden y se detiene
en el primero que responde; si ninguno responde, tus tipos de cambio actuales se mantienen.
Los tipos de cambio obtenidos se guardan en caché durante 1 día, y esa caché es la que respalda la visualización
de precios que ven los compradores. **Sincronizar tipos de cambio** —tanto si haces clic en el botón, como si ejecutas
`wp mhmcs rates-sync` o dejas que se ejecute la tarea programada— siempre omite la caché
y va directamente a la API.

*Cambiado en la versión 2.1.0.* Antes la cadena tenía dos alternativas, Currency API y después
Frankfurter, y ahora tiene una. La cobertura no cambia: el feed del BCE ya era
la última etapa de la cadena anterior, con unas treinta monedas; solo ha desaparecido la
etapa intermedia. Si tu tienda restringe las peticiones salientes a una
lista de permitidos, permite `www.ecb.europa.eu`.

Si tienes acceso al servidor, también puedes sincronizar los tipos de cambio o vaciar la caché desde la línea de comandos: consulta [Comandos de WP-CLI](/docs/wp-cli).

Las preguntas frecuentes completas están en la página de [Preguntas frecuentes](/docs/faq); la lista completa de limitaciones conocidas está
en la página de [Limitaciones conocidas](/docs/known-limits).
