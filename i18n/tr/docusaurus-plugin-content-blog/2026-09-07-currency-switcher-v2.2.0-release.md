---
slug: currency-switcher-v2.2.0-release
title: "Currency Switcher 2.2.0 — Ziyaretçi IP adresleri artık sunucunuzdan çıkmıyor"
authors: [maxhandmade]
tags: [release, currency-switcher, privacy, geolocation]
date: 2026-09-07T13:25
---

2.2.0 bir gizlilik düzeltmesi. Yerel MaxMind veritabanı olmayan bir mağazada konum algılama, her yeni ziyaretçinin IP adresini uzak bir konum servisine gönderebiliyordu. Artık gönderemez. Konum algılama yeni kurulumlarda da varsayılan olarak kapalı geliyor. Ona güveniyorsanız son bölümü okuyun: bazı mağazalarda çalışmaya devam etmesi için artık tek bir ayar gerekiyor.

<!--truncate-->

## Ne değişti

Eklenti, ziyaretçinin para birimini algılamak için WooCommerce'e ziyaretçinin hangi ülkede olduğunu sorar. WooCommerce'in yerel bir MaxMind veritabanı yoksa bu soru uzak bir konum servisine düşebiliyor ve o servis ziyaretçinin IP adresini alıyordu. WooCommerce'in kendi vitrin kodu bu yedeği kapatır; bu eklenti ise aynı işlevi varsayılan ayarlarıyla çağırdığı için bu özellikte yedek açık kalıyordu. 2.2.0 onu da kapatıyor. Algılama artık yalnızca CloudFlare'in ülke başlığını ya da kendi sunucunuzdaki bir MaxMind veritabanını kullanıyor — **ziyaretçiye dair hiçbir şey sunucunuzdan çıkmıyor**.

## Konum algılama yeni kurulumlarda kapalı başlıyor

Ziyaretçinin ülkesini IP adresinden çıkarmak bir veri işleme olduğu için yeni bir kurulumda artık **Gelişmiş** sekmesinden bilerek açtığınız bir özellik. **Güncelleyen mağazalar daha önce seçtikleri ayarı korur** — sizin yerinize hiçbir şey kapatılmaz.

## ⚠️ Konum algılamayı CloudFlare veya MaxMind olmadan kullanıyorsanız

Algılama artık uzak bir servise sormak yerine sonuç bulamayacak ve ziyaretçiler bir para birimi seçene kadar ana para biriminizi görecek. Özelliği korumak için **WooCommerce > Ayarlar > Entegrasyon > MaxMind Geolocation** altına ücretsiz bir MaxMind GeoLite2 lisans anahtarı ekleyin. WooCommerce veritabanını indirip güncel tutar ve her sorgu kendi sunucunuzda yapılır. Gelişmiş sekmesi artık, ayar açık olsun ya da olmasın, konum algılamanın neye ihtiyaç duyduğunu söylüyor. Ayrıntılar: [Gelişmiş Ayarlar](/docs/advanced-settings) ve [Para Birimi Algılama Mekanizması](/docs/currency-detection).

[GitHub'da 2.2.0](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.2.0)
