---
sidebar_position: 14
title: "Límites conocidos"
slug: /known-limits
---

# Límites conocidos

Son consecuencias de cómo funciona el plugin, no defectos. Se enumeran aquí para que puedas decidir con conocimiento de causa.

## Modo de compatibilidad con la caché

### Desactivar el modo no restaura exactamente el comportamiento de la 1.0.0

Hay tres correcciones que están por encima del ajuste y se mantienen tanto si está activado como si no: los precios ya no se convierten en las pantallas de administración ni en el AJAX de administración (que antes escribía un precio convertido en una línea de pedido), las lecturas REST de `wc/v3` quedan fijadas a la moneda base, y las tareas programadas y WP-CLI ya no convierten. Desactivar el modo restaura el comportamiento de *visualización* de la 1.0.0 —precios convertidos en el servidor— y nada más.

*Desde la 1.1.0.* Si alguna de esas reglas es incorrecta para un contexto de terceros que el plugin no puede ver, el filtro `mhmcs_should_convert` es la vía de escape. Recibe la decisión y la rama que la produjo —una de `force`, `admin`, `rest`, `cron_cli`, `cache_compat_off`, `money`, `logged_in`, `pre_wp`, `display`— y devolver `true` hace que se convierta, mientras que `false` mantiene la moneda base. Una vez que una petición ha decidido convertir, el filtro no se vuelve a consultar en esa petición: reabrir la respuesta a mitad del renderizado es lo que antes permitía que una página mostrara precios base mientras su pago por AJAX cobraba el importe convertido.

### Los motores de búsqueda y los rastreadores ven tus precios base

Con el modo activado, la página que obtiene un rastreador no ha pasado por el navegador, así que lleva precios en la moneda base, y lo mismo ocurre con los datos de producto legibles por máquinas que contiene. Consulta la pregunta relacionada en las [preguntas frecuentes](/docs/faq); la discrepancia es intencionada.

### Los precios convertidos sustituyen a los base un momento después de que aparezca la página

La página llega con tus precios en la moneda base ya en pantalla —no se oculta nada a la espera de JavaScript— y el navegador los sustituye por los convertidos en cuanto vuelve su petición, con un fundido de 200 ms en cada precio al cambiar. Con una conexión lenta, el precio base se puede leer durante más tiempo antes de la sustitución. Los visitantes que hayan pedido a su sistema reducir el movimiento ven la sustitución sin el fundido.

### Con JavaScript desactivado, o si no se puede acceder al endpoint, se mantienen los precios base

No se rompe nada y no se muestra ningún error al visitante: la página simplemente conserva los precios en la moneda base con los que se renderizó, y el motivo se escribe en la consola del navegador. El carrito y el pago no se ven afectados, porque nunca dependieron del navegador.

### Los productos variables hacen una petición adicional, y algunos plugins de muestras pierden el precio

En una página que se puede almacenar en caché, el plugin obliga a WooCommerce a obtener los precios de las variaciones por AJAX, porque el JSON de variaciones que WooCommerce incrustaría en la página lleva precios en la moneda base que sus propios scripts escriben directamente en la página. El coste es una petición cuando un visitante elige una variación, y que `data-product_variations` sea `false`: los plugins de terceros de muestras de color o talla que leen los precios de ese JSON en lugar de pedírselos a WooCommerce pueden dejar de mostrar un precio. Si usas un plugin de ese tipo, comprueba un producto variable antes de publicar el sitio.

### El minicarrito depende de los fragmentos del carrito de WooCommerce

El minicarrito se renderiza en todas las páginas, así que no se puede clasificar por petición. Se renderiza en la moneda base y luego se corrige con la propia actualización de fragmentos del carrito de WooCommerce, que es una conversión en el servidor. Si los fragmentos del carrito están desactivados en tu sitio —algunos temas y plugins de optimización los desencolan—, el total del minicarrito en caché se queda en la moneda base mientras el resto de la página se convierte. El plugin lo vigila y lo indica en la administración cuando ocurre; un sitio que no tenga minicarrito nunca recibe ese aviso.

### Un carrito o un pago en una página que WooCommerce no conoce debe excluirse de tu caché

Las cachés de página excluyen el carrito y el pago automáticamente porque reconocen las páginas que WooCommerce asignó. Si has puesto un shortcode o bloque de carrito o de pago en otra página, excluye esa página tú mismo. De lo contrario fallan dos cosas: la decisión de conversión cambia a «convertir» a mitad del renderizado, de modo que el resto de la página se imprime ya convertido y sin los marcadores que busca el navegador, y el carrito y el pago basados en bloques incrustan sus importes en la página como JSON durante el renderizado. En cualquier caso, la moneda del primer visitante es la que la caché entrega después a todos. El contenido del carrito es personal de todos modos; una página así no debería almacenarse en caché.

### `?currency=` multiplica tus entradas de caché

Se puede solicitar una moneda en la URL, y una caché trata cada URL distinta como una entrada independiente, así que enlazar a `?currency=EUR` y `?currency=GBP` almacena la misma página más de una vez. El selector en sí no genera estas URL: escribe una cookie y deja la dirección tal cual. En una página en caché, convierte los precios donde están; en la página del carrito, para un visitante conectado o con la compatibilidad con la caché desactivada, recarga la página. En ambos casos la URL es la misma en la que ya estaba el visitante, así que no se crea ninguna entrada de caché adicional.

Un enlace `?currency=` también se aplica solo a esa visualización de la página: no establece ninguna cookie a propósito, así que la siguiente página que abra el visitante vuelve a estar en tu moneda base salvo que use el selector. No es un descuido: un enlace que fijara una moneda sin avisar podría mostrar una moneda en el catálogo mientras el carrito, que lee la cookie, cobra en otra. Si quieres un enlace de campaña que se mantenga, envía a los visitantes a una página que tenga el selector en lugar de depender del parámetro.

### WooCommerce Analytics suma monedas diferentes

Un pedido se guarda en la moneda en la que pagó el cliente, y WooCommerce Analytics muestra las cifras de todos los pedidos en la moneda de tu tienda sin volver a convertirlas. Un pedido de 4,38 USD se cuenta como 4,38 en tu moneda base, así que, en cuanto aceptas pedidos en más de una moneda, las cifras de ingresos de Analytics y los totales del panel del cliente en la pantalla del pedido son sumas de importes heterogéneos. Los pedidos en sí son correctos: cada uno conserva su propia moneda, su total y el tipo de cambio con el que se realizó, y este plugin guarda ese tipo en el pedido. Son los informes agregados los que no pueden leerse como dinero. Nada en este plugin puede corregirlo desde fuera; si necesitas informes multimoneda precisos, exporta los pedidos y conviértelos usando el tipo registrado en cada uno.

### Los visitantes conectados se convierten en el servidor

Los visitantes conectados siguen la ruta del servidor, lo cual es correcto siempre que tu caché haga lo que hacen casi todas: no servir nunca páginas en caché a usuarios conectados. Una caché perimetral o una CDN configurada para almacenar en caché sin mirar las cookies es la excepción, y en ese caso la página convertida de un visitante conectado puede almacenarse y servirse a otros. Si usas caché perimetral, confirma que varía según la cookie de inicio de sesión.
