---
sidebar_position: 13
title: "Preguntas frecuentes"
slug: /faq
---

# Preguntas frecuentes

Esta página combina las preguntas frecuentes del readme.txt del plugin con unas cuantas preguntas específicas para los lectores de esta guía. Cuando una pregunta aparece en ambos sitios, aquí se usa la respuesta del readme: readme.txt es la fuente de referencia.

### ¿Cuántas monedas puedo añadir?

Tantas como necesite tu tienda: puedes activar todas las monedas que ofrece WooCommerce y no se reserva nada para una versión de pago. La API REST rechaza las peticiones que contienen más de 500 filas de monedas; es una protección frente a cargas excesivamente grandes y está muy por encima del número de códigos que ofrece el propio WooCommerce, así que el panel no puede alcanzarla. El único lugar donde el usuario ve un límite es el widget de precio del producto: la pestaña **Opciones de visualización** te permite mostrar ahí como máximo 5 monedas a la vez.

### ¿Cómo se obtienen los tipos de cambio?

Los tipos de cambio se obtienen de ExchangeRate-API en tiempo real, ya sea bajo demanda o según una programación que configures (cada hora, dos veces al día, a diario o solo manualmente), para que tus tipos estén actualizados sin intervención manual.

Si no se puede acceder a esa fuente, el plugin prueba una alternativa —la fuente de referencia diaria del Banco Central Europeo— antes de rendirse y dejar tus tipos actuales tal cual. Ambas se nombran, junto con sus condiciones, en la página [Gestionar monedas](/docs/managing-currencies). Si tu red bloquea la alternativa, el filtro `mhmcs_fallback_rates_url` puede apuntarla a otro sitio; desde la versión 2.1.0, el argumento de origen del filtro es siempre `ecb`, porque la cadena tiene una única alternativa.

Los tipos obtenidos se almacenan en caché durante 1 día, y esa caché solo respalda la visualización de precios que ven los compradores: una sincronización siempre la omite y va directamente a la fuente, tanto si pulsas **Sincronizar tipos de cambio** como si ejecutas el comando de WP-CLI o dejas que se ejecute la tarea programada.

### ¿Cuáles son los shortcodes?

`[mhmcs_currency_switcher]` muestra el desplegable de monedas. Acepta un atributo, `size`, que puede ser `small`, `medium` o `large`; si lo omites, se usa el tamaño guardado en Opciones de visualización.

`[mhmcs_currency_prices]` muestra el mismo precio de producto en varias monedas. Todos sus atributos son opcionales:

- `currencies`: códigos separados por comas, p. ej. `currencies="USD,EUR"`. Sin él, se usan las monedas elegidas en Opciones de visualización. Los códigos que no hayas configurado como monedas se ignoran.
- `product_id`: muestra el precio de un producto concreto en lugar del que se está viendo.
- `price`: muestra el precio de un importe concreto en lugar del de un producto.
- `show_flags`: `true` o `false`, que sustituye el ajuste guardado en Opciones de visualización.

Ambos están disponibles también como widgets de Elementor. Consulta [Colocar el selector](/docs/placing-the-switcher) para ver el historial de cambios de nombre de los shortcodes y todas las formas de añadirlos a tu sitio.

### ¿Puedo establecer un precio fijo para un producto concreto?

Sí. Usa la pestaña **Precios por moneda** en la pantalla de edición del producto; consulta [Precios fijos por producto](/docs/fixed-prices) para conocer los detalles. Algo que conviene saber: un precio fijo se guarda por producto y moneda, no por tipo de precio, así que se usa el mismo importe para el precio normal y el precio rebajado. Un producto que está rebajado en tu moneda base aparece como no rebajado en una moneda a la que le hayas asignado un precio fijo. Si quieres que la rebaja se mantenga, deja esa moneda con el tipo de cambio en lugar de fijarla.

### ¿Es compatible el plugin con HPOS de WooCommerce?

Sí. MHM Currency Switcher es totalmente compatible con el almacenamiento de pedidos de alto rendimiento de WooCommerce (HPOS / tablas de pedidos personalizadas).

### ¿En qué moneda se registran los pedidos?

En la moneda que estuviera usando el cliente cuando realizó el pedido. El pedido guarda el código de moneda, el tipo de cambio que se aplicó y la moneda base de tu tienda en ese momento. Ese registro es lo que te permite exportar los pedidos y recalcularlos correctamente con sus propios tipos, aunque WooCommerce Analytics sume los pedidos realizados en distintas monedas en un único total engañoso.

### ¿Al quitar una moneda se borran sus datos?

No. Quitar una moneda de la lista solo la elimina de tu configuración. Los pedidos ya realizados en esa moneda, y el tipo de cambio registrado en ellos, no se ven afectados.

### ¿Hay un límite de llamadas al endpoint de conversión?

Sí. Cuando el modo de compatibilidad con la caché está activado, los precios de las páginas en caché se convierten mediante un endpoint REST público, y una misma dirección puede llamarlo 120 veces por minuto de forma predeterminada. La navegación normal está muy lejos de esa cifra: una página hace una sola petición. Si tu tienda está detrás de un proxy inverso o de una CDN que hace que todos los visitantes parezcan la misma dirección, aumenta o desactiva el límite con el filtro `mhmcs_convert_rate_limit`. Ten en cuenta que la dirección se lee de las cabeceras de proxy que transmite WooCommerce, en las que confía incondicionalmente y que pueden falsificarse; el límite frena las llamadas masivas accidentales, no a un atacante decidido.

### Veo un aviso de que no se está aplicando la compatibilidad con la caché. ¿Qué significa?

Algunos temas y plugins definen la constante del carrito de WooCommerce en todas las páginas, normalmente para mostrar el total del carrito en la cabecera. Cuando eso ocurre, el plugin trata todas las páginas como si fueran de pago —está en juego el dinero del cliente— y convierte los precios en el servidor, que es justo lo que el modo de compatibilidad con la caché pretende evitar. En el sitio no se ve nada raro: los precios siguen siendo correctos para quien carga la página primero, y después una caché de página puede servir la moneda de esa persona a todos los demás. Como no hay ningún síntoma visible, el plugin lo indica en la administración.

**Qué página nombra.** El aviso nombra la primera página en la que se detectó el problema (solo la ruta, sin cadena de consulta) y sigue nombrando esa página mientras dure el problema, aunque otras páginas muestren el mismo problema. Una visita a la página real del carrito o de pago no cuenta en ningún sentido: allí la constante se define legítimamente.

**Cuándo desaparece.** Cuando esa misma página vuelve a generarse con normalidad, cuando esa página deja de existir (una petición a ella devuelve «no encontrado») o en cuanto guardas los ajustes con la compatibilidad con la caché desactivada. Una copia servida desde tu caché de página nunca llega a la comprobación del plugin en el servidor, así que vacía la caché después de corregir el tema.

**Quién lo ve y dónde.** Solo se muestra a los usuarios que pueden gestionar WooCommerce, y solo en tres pantallas: la página de ajustes de este plugin, **WooCommerce > Ajustes** y **WooCommerce > Estado**.

**Posponerlo.** **Posponer hasta que esto cambie** oculta el aviso solo para ti —los demás usuarios que pueden gestionar WooCommerce lo siguen viendo— hasta que el aviso desaparezca. Si el problema vuelve después, el aviso se muestra de nuevo, incluso en la misma página.

### Veo un aviso de que el minicarrito se queda en la moneda base. ¿Qué significa?

En una página que se almacena en caché, el minicarrito se muestra en tu moneda base y después lo actualiza el script `wc-cart-fragments` de WooCommerce. Esa actualización pasa por el servidor, que es donde se hace la conversión. Los temas y los plugins de optimización suelen eliminar el script para ganar velocidad, y cuando lo hacen, todos los demás precios de la página se convierten en el navegador mientras el total del minicarrito se queda en tu moneda base.

El aviso solo aparece cuando se cumplen las cuatro condiciones: la compatibilidad con la caché está activada, la página es de las que se almacenan en caché (un visitante sin sesión iniciada en una página que no es la del carrito, la de pago ni la de la cuenta), se ha llegado a mostrar un minicarrito y WordPress no ha incluido el script en esa página. Una tienda sin minicarrito nunca lo ve, aunque se haya eliminado el script. Para solucionarlo, deja que el script vuelva a cargarse o quita el minicarrito de las páginas en caché.

Nombra una página, se muestra a las mismas personas en las mismas pantallas y se pospone de la misma forma que el aviso de compatibilidad con la caché anterior. Desaparece por sí solo cuando esa misma página se genera para un visitante sin sesión iniciada con el script cargado —o, si has quitado el minicarrito, para un visitante sin sesión iniciada que tenga algo en el carrito— o en cuanto guardas los ajustes con la compatibilidad con la caché desactivada. Navegar por tu propia tienda con la sesión iniciada nunca lo hace desaparecer, porque esa vista no es la que guarda una caché; y en cualquier página en la que esté definida la constante del carrito —el problema que indica el aviso anterior— ninguna generación cuenta tampoco como almacenable en caché, así que corrige ese primero. Igual que con el otro aviso, vacía tu caché de página después de la corrección.

### ¿Por qué los datos estructurados muestran una moneda distinta del precio de la página?

Con la compatibilidad con la caché activada, la página se genera en tu moneda base y el navegador convierte los precios después, así que los datos de producto legibles por máquina que lee un rastreador se quedan en la moneda base. Es intencionado y no se corrige: fijarlos de la otra forma haría que los datos no coincidieran con la página en el único caso en que ahora coinciden: con la compatibilidad con la caché desactivada, cuando tanto la página como los datos estructurados se convierten en el servidor.

### ¿La API REST de WooCommerce devuelve precios convertidos?

Solo cuando la petición pide una moneda: `?currency=EUR` en una petición de producto `wc/v3` convierte `price`, `regular_price` y `sale_price` y añade un campo `currency_code`. Sin el parámetro, la respuesta se fija a tu moneda base, así que el resultado nunca depende de las cookies de quien hace la llamada. Aquí, un precio fijo por producto tiene prioridad sobre el tipo de cambio, exactamente igual que en la página de la tienda.

Una limitación conocida: el campo `price_html` no se fija de la misma forma. Un cliente `wc/v3` normal no puede llegar a él en ese estado —solo el código que lanza una petición REST interna durante la generación de una página—, así que ninguna integración lo ve, pero no es coherente con los tres campos numéricos y se deja constancia aquí en lugar de callarlo.

### Los precios no cambian: ¿qué debo comprobar?

1. Asegúrate de que la moneda está **Activa**.
2. Confirma que el tipo de cambio no es cero: con un tipo cero, los precios se quedan sin convertir.
3. Obtén un tipo de cambio actualizado con el botón **Sincronizar tipos de cambio**.
4. Vacía la caché de tu navegador (Ctrl+Mayús+R).
5. Si usas un plugin de caché de página, vacía su caché: la moneda seleccionada se guarda en una cookie, así que una página en caché puede seguir mostrando una moneda antigua.

### ¿Qué pasa con mis datos si borro el plugin?

De forma predeterminada, al borrar el plugin se conservan tus ajustes, la configuración de monedas y la moneda y el tipo de cambio registrados en cada pedido; el borrado solo elimina lo que nunca debería quedar, como los tipos en caché, las tareas programadas y los secretos guardados por ajustes que ya se han eliminado. Para que el plugin lo elimine todo, incluidos los datos de moneda de los pedidos (tanto en los metadatos de pedido clásicos como en las tablas de pedidos de las tiendas que usan HPOS), activa **Borrar todos los datos al eliminar el plugin** en [Ajustes avanzados](/docs/advanced-settings) antes de borrarlo. Si dejas esa opción desactivada, tu historial de ventas multimoneda se conserva incluso después de que el plugin desaparezca.

¿Hay algo que no se responda aquí? Abre una incidencia en
[GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/issues).
