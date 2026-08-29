---
sidebar_position: 2
title: Kurulum
slug: /installation
---

# Kurulum ve Gereksinimler

## Gereksinimler

| Gereksinim | Minimum Sürüm |
|-----------|---------------|
| WordPress | 6.6 |
| PHP | 7.4 |
| WooCommerce | 7.4 |

## Kurulum Adımları

1. `mhm-currency-switcher` klasörünü `/wp-content/plugins/` dizinine yükleyin
2. **Eklentiler** menüsünden eklentiyi etkinleştirin
3. WooCommerce'in yüklü ve etkin olduğundan emin olun
4. **WooCommerce > MHM Para Birimi** sayfasına gidin

Yönetim sayfasını görebilmek için `manage_woocommerce` yetkisine sahip olmanız gerekir (mağaza yöneticisi ve site yöneticisi rolleri bu yetkiye sahiptir).

## Etkinleştirme Sonrası Durum

Eklenti ilk etkinleştirildiğinde:

- **Para birimi listesi boş başlar.** Hazır para birimi eklenmez; istediklerinizi kendiniz eklersiniz.
- Konum algılama **açık** olarak gelir.
- Dönüştürücü görünümü şu varsayılanlarla gelir: bayrak **açık**, simge **açık**, kod **açık**, para birimi adı **kapalı**, boyut **Orta**.
- Önbellek uyumluluğu modu **açık** olarak gelir (bkz. [Gelişmiş Ayarlar](/docs/advanced-settings)).

> **Not:** Ana para biriminiz (base currency) her zaman WooCommerce ayarlarından okunur. Değiştirmek için **WooCommerce > Ayarlar > Genel > Para birimi seçenekleri** bölümüne gidin. Ana para birimini eklentinin para birimi listesine ekleyemezsiniz — o zaten çevirinin çıkış noktasıdır.

## Yönetim Sekmeleri

Eklentinin yönetim ekranı dört sekmeden oluşur:

| Sekme | İçerik |
|-------|--------|
| **Para Birimlerini Yönet** | Para birimi listesi, kur, komisyon, yuvarlama, sıralama |
| **Görüntüleme Seçenekleri** | Dönüştürücünün görünümü ve ürün fiyat bileşeni |
| **Gelişmiş** | Konum algılama, otomatik kur güncelleme aralığı ve önbellek uyumluluğu |
| **Nasıl kullanılır** | Dönüştürücünün sitenize nerelerde yerleştirilebileceğini gösteren kopyalanabilir kod örnekleri |

Değişiklikleriniz kaydedilmemişse sayfanın üstünde bir uyarı çubuğu belirir. **Değişiklikleri Kaydet** düğmesi hem bu çubukta hem de sayfanın altında bulunur ve dört sekmedeki tüm değişiklikleri tek seferde kaydeder.
