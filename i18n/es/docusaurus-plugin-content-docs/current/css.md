---
sidebar_position: 11
title: "Personalización con CSS"
---

# Personalización con CSS

Añade tus modificaciones en **Apariencia > Personalizar > CSS adicional** o en la hoja de estilos de tu tema. La forma más rápida de encontrar lo que necesitas es inspeccionar el selector en las herramientas de desarrollo de tu navegador: las clases que aparecen a continuación son las que realmente figuran en el código que genera el plugin, así que nada de lo que hay aquí se basa en suposiciones.

*Renombradas en la 2.1.0.* Todas las clases de esta página llevaban antes el prefijo `mhm-cs-` y ahora llevan `mhmcs-`. No se mantiene ningún alias para los nombres antiguos, por lo que el CSS o JavaScript personalizado escrito con los nombres anteriores dejará de coincidir en cuanto actualices; cambia tus selectores a los nombres que se indican a continuación.

## Cambios habituales

**Cambiar el color del botón del selector:**

```css
.mhmcs-selected {
    background-color: #1a1a2e;
    color: #ffffff;
    border-color: #16213e;
}
```

**Ensanchar el desplegable:**

```css
.mhmcs-switcher .mhmcs-dropdown {
    min-width: 200px;
}
```

Las reglas de posicionamiento del desplegable usan `!important` (para resistir conflictos con el tema), así que para sobrescribir la posición o la visibilidad normalmente necesitas un selector al menos tan específico como el anterior, en lugar de un simple `.mhmcs-dropdown`.

**Alinear el selector dentro de un menú de navegación:**

```css
.menu-item.mhmcs-menu-item .mhmcs-dropdown {
    left: auto;
    right: 0;
    min-width: 160px;
}
```

**Cambiar el tamaño del widget de precio del producto:**

```css
.mhmcs-product-prices {
    font-size: 16px;
    color: #333;
}
```

Por debajo de 480px, el widget ya se apila verticalmente y oculta sus separadores por sí solo; no hace falta hacer nada más para ese punto de ruptura.

## Referencia de clases

| Zona | Clases |
|---|---|
| Contenedor / tamaño del selector | `.mhmcs-switcher`, `.mhmcs-size--small`, `.mhmcs-size--medium`, `.mhmcs-size--large` |
| Botón / desplegable del selector | `.mhmcs-selected`, `.mhmcs-arrow`, `.mhmcs-label`, `.mhmcs-flag`, `.mhmcs-dropdown`, `.mhmcs-dropdown.mhmcs-open`, `.mhmcs-option`, `.mhmcs-active` |
| Elemento del menú de navegación | `.menu-item.mhmcs-menu-item` |
| Widget de precio del producto | `.mhmcs-product-prices`, `.mhmcs-product-price`, `.mhmcs-separator`, `.mhmcs-amount` |

Todas estas son clases de la parte pública. Las clases de precio de variaciones, como `mhmcs-variation-prices`, no se incluyen en esta página: pertenecen al panel de precios de variaciones, exclusivo de la administración, que solo aparece en la pantalla de Productos de WooCommerce.
