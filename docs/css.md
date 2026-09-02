---
sidebar_position: 11
title: Customizing with CSS
---

# Customizing with CSS

Add your overrides in **Appearance > Customize > Additional CSS**, or your theme's stylesheet. The quickest way to find what you need is to inspect the switcher in your browser's dev tools — the classes below are the ones that actually appear in the markup the plugin outputs, so nothing here relies on guesswork.

*Renamed in 2.1.0.* Every class on this page used to carry the `mhm-cs-` prefix and now carries `mhmcs-`. No alias is kept for the old names, so custom CSS or JavaScript written against the old spellings stops matching once you update — switch your selectors to the names below.

## Common changes

**Recolor the switcher button:**

```css
.mhmcs-selected {
    background-color: #1a1a2e;
    color: #ffffff;
    border-color: #16213e;
}
```

**Widen the dropdown:**

```css
.mhmcs-switcher .mhmcs-dropdown {
    min-width: 200px;
}
```

The dropdown's positioning rules use `!important` (to survive theme conflicts), so overriding position or visibility usually needs a selector at least as specific as the one above rather than a bare `.mhmcs-dropdown`.

**Align the switcher inside a nav menu:**

```css
.menu-item.mhmcs-menu-item .mhmcs-dropdown {
    left: auto;
    right: 0;
    min-width: 160px;
}
```

**Resize the product price widget:**

```css
.mhmcs-product-prices {
    font-size: 16px;
    color: #333;
}
```

Below 480px the widget already stacks vertically and hides its separators on its own — no extra work needed for that breakpoint.

## Class reference

| Area | Classes |
|---|---|
| Switcher container / size | `.mhmcs-switcher`, `.mhmcs-size--small`, `.mhmcs-size--medium`, `.mhmcs-size--large` |
| Switcher button / dropdown | `.mhmcs-selected`, `.mhmcs-arrow`, `.mhmcs-label`, `.mhmcs-flag`, `.mhmcs-dropdown`, `.mhmcs-dropdown.mhmcs-open`, `.mhmcs-option`, `.mhmcs-active` |
| Nav menu item | `.menu-item.mhmcs-menu-item` |
| Product price widget | `.mhmcs-product-prices`, `.mhmcs-product-price`, `.mhmcs-separator`, `.mhmcs-amount` |

These are all front-end classes. Variation price classes such as `mhmcs-variation-prices` are not included on this page: they belong to the admin-only variation pricing panel, which appears only on the WooCommerce Products screen.
