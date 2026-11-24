---
slug: currency-switcher-v2.2.1-release
title: "Currency Switcher 2.2.1: turco dentro del plugin y avisos de caché que ya no desaparecen"
authors: [maxhandmade]
tags: [release, currency-switcher, translation, cache]
date: 2026-09-18T20:07
---

La versión 2.2.1 corrige dos cosas que podías ver. En un sitio en turco, el plugin aparecía en inglés, y los dos avisos de compatibilidad con la caché se borraban y volvían a aparecer una y otra vez. Ambos problemas están corregidos y no tienes que hacer nada después de actualizar.

{/* truncate */}

## La traducción al turco se incluye con el plugin

Al instalarlo desde WordPress.org, el plugin aparecía en inglés en un sitio en turco: el paquete de la versión no incluía los archivos de traducción compilados y no existía ningún paquete de idioma de WordPress.org que los sustituyera. Ya vuelven a estar en el paquete. En WordPress 6.8 y posteriores, todo el plugin aparece en turco. En 6.6 y 6.7, la pantalla de ajustes aparece en turco, pero los textos que proceden del código PHP del plugin, como la etiqueta del menú, siguen en inglés; consulta [Limitaciones conocidas](/docs/known-limits). Se pueden añadir otros idiomas en [translate.wordpress.org](https://translate.wordpress.org/projects/wp-plugins/mhm-currency-switcher/).

## Los avisos de caché ya no aparecen y desaparecen

Los dos avisos de compatibilidad con la caché se borraban, junto con lo que hubiera pospuesto cada administrador, cada vez que una página no podía mostrar el problema (un cliente que abría el carrito o tú navegando por la tienda con la sesión iniciada), y la siguiente visita a una página los hacía volver. Ahora cada comprobación llega a una de tres respuestas: el problema existe, la página está limpia o esta página no permite saberlo. Un aviso sigue indicando la primera página en la que se detectó el problema y solo se borra cuando esa misma página se genera sin el problema, cuando esa página ya no existe o cuando guardas los ajustes con la compatibilidad con la caché desactivada. **Posponer hasta que esto cambie** ahora se mantiene, y ambos avisos indican cuándo se borran. El funcionamiento de cada aviso se describe en las [preguntas frecuentes](/docs/faq).

[La versión 2.2.1 en GitHub](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.2.1)
