---
sidebar_position: 4
title: Görüntüleme Seçenekleri
slug: /display-options
---

# Görüntüleme Seçenekleri

**WooCommerce > MHM Para Birimi > Görüntüleme Seçenekleri** sekmesi

## Dönüştürücü Görünümü

| Ayar | Açıklama | Varsayılan |
|------|----------|-----------|
| **Bayrak simgesi göster** | Para biriminin yanında ülke bayrağı gösterir | Açık |
| **Para birimi adını göster** | Tam adı gösterir (örn. "Türk Lirası") | **Kapalı** |
| **Para birimi simgesi göster** | Simgeyi gösterir (örn. "₺", "€") | Açık |
| **Para birimi kodunu göster** | ISO kodunu gösterir (örn. "TRY", "EUR") | Açık |

Etiket metni açık olan parçalardan sırayla oluşturulur: **simge → kod → ad**. Dördünü birden kapatırsanız etiket boş kalmaz; para birimi kodu yedek olarak gösterilir.

## Dönüştürücü Boyutu

| Boyut | Yazı boyutu |
|-------|-------------|
| **Küçük** | 12px |
| **Orta** (varsayılan) | 14px |
| **Büyük** | 16px |

## Ürün Fiyat Bileşeni

Ürün sayfalarında ana fiyatın altında, fiyatı birkaç para biriminde birden gösteren şerittir.

| Ayar | Açıklama |
|------|----------|
| **Ürün fiyat bileşenini etkinleştir** | Bileşeni açar/kapatır |
| **Gösterilecek para birimleri** | En fazla 5 para birimi seçebilirsiniz |
| **Bileşende bayrakları göster** | Fiyatların yanında bayrak simgesi gösterir |

Bileşen açıkken ürün sayfasında fiyat özetinin içinde otomatik olarak görünür; kısa kodu elle eklemenize gerek yoktur. Hiçbir para birimi seçilmemişse bileşen görünmez.

**Örnek görünüm:**

```
Ürün Fiyatı: ₺500,00

€14,17 | $15,50 | £12,30
```

## Canlı Önizleme

Sekmenin altında, seçtiğiniz ayarlara göre basit bir önizleme gösterilir. Bu sadeleştirilmiş bir temsildir — gerçek görünüm temanıza göre değişebilir.

## Sayfa Yenilenmeden Dönüştürme

Önbellek uyumluluğu modu açıkken (varsayılan durum — bkz. [Gelişmiş Ayarlar](/docs/advanced-settings)) ziyaretçi mağaza, kategori veya ürün sayfasındaki dönüştürücüden para birimi değiştirdiğinde sayfa **yeniden yüklenmez**: eklenti çerezi yazar, sayfadaki fiyatları olduğu yerde dönüştürür ve mini sepeti tazeler. Sepet sayfasında, oturum açmış bir ziyaretçide veya önbellek uyumluluğu kapatıldığında sayfa eskisi gibi yeniden yüklenir.
