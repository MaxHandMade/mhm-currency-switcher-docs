---
sidebar_position: 11
title: Customizing with CSS
---

# Customizing with CSS

Add your overrides in **Appearance > Customize > Additional CSS**, or your theme's stylesheet. The quickest way to find what you need is to inspect the switcher in your browser's dev tools — the classes below are the ones that actually appear in the markup the plugin outputs, so nothing here relies on guesswork.

## Common changes

**Recolor the switcher button:**

```css
.mhm-cs-selected {
    background-color: #1a1a2e;
    color: #ffffff;
    border-color: #16213e;
}
```

**Widen the dropdown:**

```css
.mhm-cs-switcher .mhm-cs-dropdown {
    min-width: 200px;
}
```

The dropdown's positioning rules use `!important` (to survive theme conflicts), so overriding position or visibility usually needs a selector at least as specific as the one above rather than a bare `.mhm-cs-dropdown`.

**Align the switcher inside a nav menu:**

```css
.menu-item.mhm-cs-menu-item .mhm-cs-dropdown {
    left: auto;
    right: 0;
    min-width: 160px;
}
```

**Resize the product price widget:**

```css
.mhm-cs-product-prices {
    font-size: 16px;
    color: #333;
}
```

Below 480px the widget already stacks vertically and hides its separators on its own — no extra work needed for that breakpoint.

## Class reference

| Area | Classes |
|---|---|
| Switcher container / size | `.mhm-cs-switcher`, `.mhm-cs-size--small`, `.mhm-cs-size--medium`, `.mhm-cs-size--large` |
| Switcher button / dropdown | `.mhm-cs-selected`, `.mhm-cs-arrow`, `.mhm-cs-label`, `.mhm-cs-flag`, `.mhm-cs-dropdown`, `.mhm-cs-dropdown.mhm-cs-open`, `.mhm-cs-option`, `.mhm-cs-active` |
| Nav menu item | `.menu-item.mhm-cs-menu-item` |
| Product price widget | `.mhm-cs-product-prices`, `.mhm-cs-product-price`, `.mhm-cs-separator`, `.mhm-cs-amount` |

These are all front-end classes. Variation price classes such as `mhm-cs-variation-prices` are not included on this page: they belong to the admin-only variation pricing panel, which appears only on the WooCommerce Products screen.
