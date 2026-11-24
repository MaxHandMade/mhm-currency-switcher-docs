---
sidebar_position: 10
title: "Conversión de divisas"
slug: /currency-conversion
---

# Conversión de divisas

## La fórmula

```
Converted price = Base price × Effective rate   → rounding (if set)
```

El tipo de cambio efectivo incorpora el tipo de comisión que tenga cada divisa:

| Tipo de comisión | Fórmula |
|---|---|
| Ninguna | Tipo efectivo = Tipo bruto |
| Porcentaje | Tipo efectivo = Tipo bruto × (1 + Comisión / 100) |
| Fija | Tipo efectivo = Tipo bruto + Comisión fija |

**Ejemplo**: divisa base TRY, precio del producto 500:

| Divisa | Tipo bruto | Comisión | Tipo efectivo | Precio convertido |
|---|---|---|---|---|
| EUR | 0.0267 | 2.5% | 0.0274 | €13.68 |
| USD | 0.0293 | Ninguna | 0.0293 | $14.65 |
| GBP | 0.0230 | 0.002 fija | 0.0250 | £12.50 |

Si el tipo de cambio de una divisa es 0, o no se encuentra la divisa, el precio se deja sin convertir en lugar de mostrarse como cero.

El redondeo (Al más cercano / Hacia arriba / Hacia abajo, según un paso y una cantidad opcional a restar; consulta [Gestionar divisas](/docs/managing-currencies)) se aplica **después** del tipo de cambio y la comisión. No se limita a los precios de los productos: desde la versión 1.1.0 también se aplica a los gastos de envío y a las tarifas del carrito, así como a los cupones de importe fijo.

## Qué se convierte

| Campo | Comportamiento |
|---|---|
| Precio del producto (normal y rebajado) | Se convierte y se redondea |
| Precios de variaciones y rangos de precios | Se convierten y se redondean |
| Totales del carrito y del pedido | Se calculan a partir de las líneas ya convertidas |
| Tarifas del carrito | Se convierten y se redondean |
| Gastos de envío | Se convierten y se redondean |
| Impuesto del envío | Se convierte, **no se redondea**: va ligado a los gastos de envío |
| Cupones de importe fijo | Se convierten y se redondean |
| Gasto mínimo/máximo del cupón | Se convierte, **no se redondea** |

Los cupones basados en porcentaje no se modifican: un descuento del 10 % es del 10 % sea cual sea la divisa.

Las dos filas «no se redondea» son intencionadas, no descuidos: ni la línea de impuesto del envío ni el umbral de gasto de un cupón son importes que el cliente pague directamente, así que redondear cualquiera de ellos alteraría una regla (un cálculo de impuestos, un umbral fijado por el comerciante) en lugar de pulir un precio en pantalla.

## Pedidos

La divisa, el tipo de cambio y la divisa base activos en el momento del pago se guardan en el pedido. Las pantallas de administración de pedidos y los correos electrónicos de pedidos siempre muestran el importe que el cliente pagó realmente, en la divisa en la que lo pagó, y los pedidos realizados antes de instalar el plugin, o antes de un determinado cambio de precio, nunca se reescriben de forma retroactiva.
