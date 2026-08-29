---
sidebar_position: 11
title: CSS ile Özelleştirme
---

# CSS ile Özelleştirme

Görünümü temanızın stil dosyasından veya **Görünüm > Özelleştir > Ek CSS** bölümünden değiştirebilirsiniz. Aşağıdaki sınıfların tümü eklentinin ürettiği işaretlemede gerçekten bulunur.

## Dönüştürücü Sınıfları

```css
/* Ana kapsayıcı */
.mhm-cs-switcher { }

/* Boyut varyantları */
.mhm-cs-size--small  { }
.mhm-cs-size--medium { }
.mhm-cs-size--large  { }

/* Seçim düğmesi */
.mhm-cs-selected { }

/* Açılır liste */
.mhm-cs-dropdown { }

/* Açılır liste açıkken */
.mhm-cs-dropdown.mhm-cs-open { }

/* Listedeki her bir seçenek */
.mhm-cs-option { }

/* Seçili olan seçenek */
.mhm-cs-active { }

/* Bayrak görseli */
.mhm-cs-flag { }

/* Düğmedeki etiket metni */
.mhm-cs-label { }

/* Açılır ok */
.mhm-cs-arrow { }

/* Menüye eklendiğinde menü öğesi */
.menu-item.mhm-cs-menu-item { }
```

## Ürün Fiyat Bileşeni Sınıfları

```css
/* Bileşen kapsayıcısı */
.mhm-cs-product-prices { }

/* Her bir fiyat öğesi */
.mhm-cs-product-price { }

/* Fiyatlar arasındaki ayırıcı */
.mhm-cs-separator { }

/* Fiyat tutarı */
.mhm-cs-amount { }
```

## Özelleştirme Örnekleri

**Dönüştürücü düğmesinin rengini değiştirme:**

```css
.mhm-cs-selected {
    background-color: #1a1a2e;
    color: #ffffff;
    border-color: #16213e;
}
```

**Açılır menüyü genişletme:**

```css
.mhm-cs-switcher .mhm-cs-dropdown {
    min-width: 200px;
}
```

> Açılır listenin kuralları tema çakışmalarına karşı `!important` ile korunduğu için, konum ve görünürlük değerlerini geçersiz kılarken sizin de `.mhm-cs-switcher .mhm-cs-dropdown` gibi daha özgül bir seçici kullanmanız gerekebilir.

**Menüdeki dönüştürücüyü hizalama:**

```css
.menu-item.mhm-cs-menu-item .mhm-cs-dropdown {
    left: auto;
    right: 0;
    min-width: 160px;
}
```

**Ürün fiyat bileşenini büyütme:**

```css
.mhm-cs-product-prices {
    font-size: 16px;
    color: #333;
}
```

480px altındaki ekranlarda fiyat bileşeni zaten alt alta dizilir ve ayırıcılar gizlenir; bu genişlikte kendi düzeninizi eklemeniz gerekmez.

## Kapsam dışı bırakılanlar

Bu sayfa yalnızca **ön yüzde** (mağaza, ürün, menü) görünen, ziyaretçinin gördüğü işaretlemeyi listeler. Yönetim ekranındaki değişken/varyasyon fiyat panelinin sınıfları (`mhm-cs-variation-prices` gibi) buraya dahil değildir — bu panel yalnızca **WooCommerce > Ürünler** ekranında görünür.
