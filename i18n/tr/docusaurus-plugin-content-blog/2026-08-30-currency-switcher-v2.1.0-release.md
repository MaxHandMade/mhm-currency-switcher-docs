---
slug: currency-switcher-v2.1.0-release
title: "Currency Switcher 2.1.0 — WordPress.org'da, her yerde tek önek"
authors: [maxhandmade]
tags: [release, currency-switcher, css, rest-api]
date: 2026-08-30T15:27
---

MHM Currency Switcher artık WordPress.org'da listeleniyor ve oraya 2.1.0 ile geldi; bundan sonra WordPress eklentinin güncellemelerini diğer eklentilerinki gibi sunuyor. Bu sürüm ayrıca, özel kodun dayanabileceği üç şeyi değiştiren bir adlandırma temizliğini tamamlıyor. Eklentiye karşı CSS, JavaScript ya da PHP yazdıysanız güncellemeden önce ilk bölümü okuyun.

{/* truncate */}

## Güncellemeden önce: adı ya da biçimi değişen üç şey

**CSS sınıfları.** Switcher'ın kullandığı her sınıfın öneki `mhm-cs-`'den `mhmcs-`'ye değişti: `.mhm-cs-switcher` artık `.mhmcs-switcher`, `.mhm-cs-dropdown` artık `.mhmcs-dropdown`; diğer bütün sınıflar da böyle. Eski adlar için takma ad bırakılmadı, bu yüzden eski adlara göre yazılmış özel CSS veya JavaScript güncellemeden sonra eşleşmeyi bırakır. Tam liste [CSS ile Özelleştirme](/docs/css) sayfasında.

**Kur yedeği.** Ana kur kaynağına ulaşılamadığında eklenti artık Avrupa Merkez Bankası'nın günlük referans kur akışına tek bir istek yapıyor. 2.0.0'da eklenen iki aşamalı zincir — önce Currency API, sonra Frankfurter — kaldırıldı. Kapsam değişmedi, yaklaşık otuz para birimi, çünkü ECB zaten eski zincirin son adımıydı. Kodunuz yedek adresi filtreliyorsa, `mhmcs_fallback_rates_url` filtresinin `$source` argümanı artık her zaman `ecb`. Bkz. [Para Birimlerini Yönet](/docs/managing-currencies).

**Herkese açık kur ucu.** Kimlik doğrulaması istemeyen `GET /mhmcs/v1/rates` REST rotası kaldırıldı; sayfanın fiyatlarında zaten görünen bilgiyi tekrarlıyordu. Ayarlar ekranının kullandığı kimlik doğrulamalı rotalar etkilenmedi. Bkz. [REST API Referansı](/docs/rest-api).

## Daha sessiz, doğru yerde duran bildirimler

- İki önbellek uyumluluğu uyarısı artık ertelenebiliyor. Ertelemek uyarıyı yalnızca o an algılanan sorun için kaldırır: sonradan farklı, yeni bir önbellek sorunu çıkarsa uyarı sonsuza dek susmak yerine geri gelir. *Sonra: 2.2.1'de erteleme, uyarı kalkana kadar tutuyor — bkz. [2.2.1 notları](/blog/currency-switcher-v2.2.1-release).*
- WooCommerce-yok bildirimi ve iki önbellek uyarısı artık her yönetim ekranında değil, yalnızca ait oldukları ekranlarda görünüyor; ve yalnızca üzerlerinde işlem yapabilecek kişilere: ilki için eklenti kurabilen kullanıcılara, diğer ikisi için WooCommerce'i yönetebilen kullanıcılara.

## Bu sürümde ayrıca

- 2026-03 sürümünden sonra hiç güncellenmemiş kurulumlar için olan ayar geçişi, kaldırma rutinindeki eşleşen eski ayar kollarıyla birlikte kaldırıldı. 1.0.0'dan (2026-07) bu yana çıkan her sürüm etkilenmez.
- Eklentide kalan son `mhm-cs-`, `mhm_cs_` ve `mhm_currency_switcher_` adları `mhmcs` önekine taşındı.
- Sürüm paketi artık `languages/` klasörünü içermiyor. *Sonra: 2.2.1 Türkçe çeviriyi eklentiye geri koydu — bkz. [2.2.1 notları](/blog/currency-switcher-v2.2.1-release).*

[GitHub'da 2.1.0](https://github.com/MaxHandMade/mhm-currency-switcher/releases/tag/v2.1.0)
