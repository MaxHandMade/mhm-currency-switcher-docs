---
sidebar_position: 11
title: CSS ile Özelleştirme
---

# CSS ile Özelleştirme

Görünümü temanızın stil dosyasından veya **Görünüm > Özelleştir > Ek CSS** bölümünden değiştirebilirsiniz. Aşağıdaki sınıfların tümü eklentinin ürettiği işaretlemede gerçekten bulunur.

*2.1.0'da yeniden adlandırıldı.* Bu sayfadaki sınıfların tümü önceden `mhm-cs-` önekini taşıyordu, artık `mhmcs-` taşıyor. Eski adlar takma ad olarak bırakılmadı; eski yazımlara göre yazılmış özel CSS veya JavaScript güncellemeden sonra eşleşmeyi bırakır — seçicilerinizi aşağıdaki adlarla değiştirin.

## Dönüştürücü Sınıfları

```css
/* Ana kapsayıcı */
.mhmcs-switcher { }

/* Boyut varyantları */
.mhmcs-size--small  { }
.mhmcs-size--medium { }
.mhmcs-size--large  { }

/* Seçim düğmesi */
.mhmcs-selected { }

/* Açılır liste */
.mhmcs-dropdown { }

/* Açılır liste açıkken */
.mhmcs-dropdown.mhmcs-open { }

/* Listedeki her bir seçenek */
.mhmcs-option { }

/* Seçili olan seçenek */
.mhmcs-active { }

/* Bayrak görseli */
.mhmcs-flag { }

/* Düğmedeki etiket metni */
.mhmcs-label { }

/* Açılır ok */
.mhmcs-arrow { }

/* Menüye eklendiğinde menü öğesi */
.menu-item.mhmcs-menu-item { }
```

## Ürün Fiyat Bileşeni Sınıfları

```css
/* Bileşen kapsayıcısı */
.mhmcs-product-prices { }

/* Her bir fiyat öğesi */
.mhmcs-product-price { }

/* Fiyatlar arasındaki ayırıcı */
.mhmcs-separator { }

/* Fiyat tutarı */
.mhmcs-amount { }
```

## Özelleştirme Örnekleri

**Dönüştürücü düğmesinin rengini değiştirme:**

```css
.mhmcs-selected {
    background-color: #1a1a2e;
    color: #ffffff;
    border-color: #16213e;
}
```

**Açılır menüyü genişletme:**

```css
.mhmcs-switcher .mhmcs-dropdown {
    min-width: 200px;
}
```

> Açılır listenin kuralları tema çakışmalarına karşı `!important` ile korunduğu için, konum ve görünürlük değerlerini geçersiz kılarken sizin de `.mhmcs-switcher .mhmcs-dropdown` gibi daha özgül bir seçici kullanmanız gerekebilir.

**Menüdeki dönüştürücüyü hizalama:**

```css
.menu-item.mhmcs-menu-item .mhmcs-dropdown {
    left: auto;
    right: 0;
    min-width: 160px;
}
```

**Ürün fiyat bileşenini büyütme:**

```css
.mhmcs-product-prices {
    font-size: 16px;
    color: #333;
}
```

480px altındaki ekranlarda fiyat bileşeni zaten alt alta dizilir ve ayırıcılar gizlenir; bu genişlikte kendi düzeninizi eklemeniz gerekmez.

## Kapsam dışı bırakılanlar

Bu sayfa yalnızca **ön yüzde** (mağaza, ürün, menü) görünen, ziyaretçinin gördüğü işaretlemeyi listeler. Yönetim ekranındaki değişken/varyasyon fiyat panelinin sınıfları (`mhmcs-variation-prices` gibi) buraya dahil değildir — bu panel yalnızca **WooCommerce > Ürünler** ekranında görünür.
